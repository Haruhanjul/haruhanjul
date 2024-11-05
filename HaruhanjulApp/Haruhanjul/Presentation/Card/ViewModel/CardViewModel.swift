//
//  CardViewModel.swift
//  Haruhanjul
//
//  Created by 임대진 on 9/5/24.
//

import SwiftUI
import WidgetKit
import CoreData
import Combine

import MLKitTranslate
import Alamofire

import NetworkKit

final class CardViewModel: ObservableObject {
    
    static let shared = CardViewModel()
    
    @Published var advices: [AdviceEntity] = []
    @Published var isLoading: Bool = true
    @Published var dragProgresses: [CGFloat] = []
    
    private let englishKoreanTranslator = Translator.translator(options: TranslatorOptions(sourceLanguage: .english, targetLanguage: .korean))
    private let conditions = ModelDownloadConditions(allowsCellularAccess: false, allowsBackgroundDownloading: true)
    private var removedAdvices: [AdviceEntity] = []
    private var removedCount = 0
    
    private let networkManager = NetworkManager(session: Session(eventMonitors: [APIEventMonitor()]))
    
    var cancellables = Set<AnyCancellable>()
    var isTranslatorReady = false
    var lastIndex = 0
    
    init() {
        lastIndex = AdviceDefaults.cardIndex
    }
    
    // View에 명언 적용
    func loadAdvices(context: NSManagedObjectContext) {
        Task {
            if !isTranslatorReady {
                await downloadTranslatorModel()
            }
            
            let (result, count) = await loadCDAdviceEntities(context: context)
            
            await MainActor.run {
                if count < 10 {
                    fetchAdvice(count: 10, context: context)
                } else {
                    dragProgresses = Array(repeating: 0, count: count)
                    removedAdvices = Array(result[0..<lastIndex])
                    advices = Array(result[lastIndex..<result.count])
                    removedCount = count
                    isLoading = false
                }
            }
        }
    }
    
    // 코어데이터 명언 불러오기
    func loadCDAdviceEntities(context: NSManagedObjectContext) async -> ([AdviceEntity], Int) {
        let fetchRequest: NSFetchRequest<CDAdviceEntity> = CDAdviceEntity.fetchRequest()
        
        do {
            let cdAdviceEntities = try context.fetch(fetchRequest)
            return (cdAdviceEntities.map { $0.toAdviceEntity() }, cdAdviceEntities.count)
        } catch {
            print("데이터 로드 실패: \(error)")
            return ([], 0)
        }
    }
    
    // 번역 API 모델 다운로드
    func downloadTranslatorModel() async {
        print("언어 모델 다운로드 시작")
        await withCheckedContinuation { continuation in
            self.englishKoreanTranslator.downloadModelIfNeeded(with: conditions) { error in
                guard error == nil else {
                    print("언어 모델 다운로드 실패: \(error!)")
                    return continuation.resume()
                }
                print("언어 모델 다운로드 완료")
                self.isTranslatorReady = true
                continuation.resume()
            }
        }
    }
    
    // 명언 API 호출
    func fetchAdvice(count: Int, context: NSManagedObjectContext) {
        Task {
            await MainActor.run {
                downloadAdvices(count: count, context: context) { [self] result in
                    dragProgresses.append(contentsOf: Array(repeating: 0, count: result.count))
                    advices.append(contentsOf: result)
                    removedCount += result.count
                    isLoading = false
                }
            }
        }
    }
    
    
    // 명언 API
    func downloadAdvices(count: Int, context: NSManagedObjectContext, completion: @escaping ([AdviceEntity]) -> ()) {
        
        var result: [AdviceEntity] = []
        let endpoint = Endpoint<AdviceDTO>(
            baseURL: .adviceslipAPI,
            path: "/advice",
            method: .get
        )
        
        let dispatchGroup = DispatchGroup()
        
        for _ in 0..<count {
            dispatchGroup.enter()
            
            networkManager.request(with: endpoint)
                .map { $0.slip.convertToEntity() }
                .sink(
                    receiveCompletion: { completion in
                        if case .failure(let error) = completion {
                            print("Request failed with error: \(error)")
                            dispatchGroup.leave()
                        }
                    },
                    receiveValue: { [self] entity in
                        englishKoreanTranslator.translate(entity.content) { translatedText, error in
                            if let error = error {
                                print("Translation error: \(error)")
                            } else {
                                let updatedAdvice = AdviceEntity(id: entity.id, content: entity.content, adviceKorean: translatedText)
                                self.saveAdviceEntity(adviceEntity: updatedAdvice, context: context)
                                result.append(updatedAdvice)
                                dispatchGroup.leave()
                            }
                        }
                    }
                )
                .store(in: &cancellables)
        }
        
        dispatchGroup.notify(queue: .main) {
            completion(result)
        }
    }
    
    // 카드 넘기기
    func removeAdvice(at index: Int) {
        guard index < advices.count else { return }
        Task {
            await MainActor.run {
                withAnimation {
                    dragProgresses[index] = 0
                }
                
                removedAdvices.append(advices.remove(at: index))
                removedCount -= 1
                lastIndex += 1
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [self] in
                    if !advices.isEmpty {
                        widgetUpdate(advice: advices[0].content, adviceKorean: advices[0].adviceKorean ?? "")
                    }
                }
            }
        }
        
        if advices.count < 5 {
            let context = PersistenceController.shared.container.viewContext
            fetchAdvice(count: 5, context: context)
        }
    }
    
    // 카드 되돌리기
    func restoreAdvice(at index: Int) {
        if !removedAdvices.isEmpty {
            dragProgresses[index] = 1
            advices.insert(removedAdvices.removeLast(), at: 0)
            removedCount += 1
            lastIndex -= 1
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [self] in
                widgetUpdate(advice: advices[0].content, adviceKorean: advices[0].adviceKorean ?? "")
            }
        }
    }
    
    // 북마크 토글
    func toggleBookmark(id: Int, isBookmarked: Bool, context: NSManagedObjectContext) {
        let fetchRequest: NSFetchRequest<CDAdviceEntity> = CDAdviceEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %d", id)
        
        do {
            let results = try context.fetch(fetchRequest)
            
            if let bookmark = results.first {
                bookmark.isBookmarked = isBookmarked
                
                try context.save()
            } else {
                print("No bookmark found id: \(id)")
            }
        } catch {
            print("Failed to fetch bookmark: \(error)")
        }
    }
    
    // 다운받은 명언을 코어데이터 저장
    func saveAdviceEntity(adviceEntity: AdviceEntity, context: NSManagedObjectContext) {
        let duplicateRequest: NSFetchRequest<CDAdviceEntity> = CDAdviceEntity.fetchRequest()
        duplicateRequest.predicate = NSPredicate(format: "id == %d", adviceEntity.id)
        
        do {
            let existingEntities = try context.fetch(duplicateRequest)
            
            if existingEntities.isEmpty {
                let cdAdviceEntity = CDAdviceEntity(context: context)
                cdAdviceEntity.update(from: adviceEntity, context: context)
                
                try context.save()
            } else {
                print("중복된 CDAdviceEntity가 존재합니다.")
            }
        } catch {
            print("CDAdviceEntity 데이터 저장 실패: \(error)")
        }
    }
    
    // 명언 카드 리셋
    func resetAdvices(context: NSManagedObjectContext) {
        Task {
            await MainActor.run {
                isLoading = true
            }
            
            await deleteAllAdviceEntities(context: context)
            
            await MainActor.run {
                removedAdvices = []
                advices = []
                removedCount = 0
                lastIndex = 0
            }
            
            fetchAdvice(count: 10, context: context)
        }
    }
    
    // 코어데이터 명언 전체 삭제
    func deleteAllAdviceEntities(context: NSManagedObjectContext) async {
        let fetchRequest: NSFetchRequest<CDAdviceEntity> = CDAdviceEntity.fetchRequest()
        
        do {
            let results = try context.fetch(fetchRequest)
            
            for object in results {
                context.delete(object)
            }
            
            try context.save()
            print("모든 명언 객체가 삭제되었습니다.")
        } catch {
            print("데이터 삭제 중 오류 발생: \(error)")
        }
    }
    
    func widgetUpdate(advice: String, adviceKorean: String) {
        AdviceDefaults.content = [advice, adviceKorean]
        WidgetCenter.shared.reloadTimelines(ofKind: "HaruhanjulWidget")
    }
}
