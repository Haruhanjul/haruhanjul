//
//  CardViewModel.swift
//  Haruhanjul
//
//  Created by 임대진 on 9/5/24.
//

import Foundation
import MLKitTranslate
import CoreData
import WidgetKit
import SwiftUI

final class CardViewModel: ObservableObject {
    
    static let shared = CardViewModel()
    
    @Published var advices: [AdviceEntity] = []
    @Published var isLoading: Bool = true
    @Published var dragProgresses: [CGFloat] = []
    
    private let englishKoreanTranslator = Translator.translator(options: TranslatorOptions(sourceLanguage: .english, targetLanguage: .korean))
    private let conditions = ModelDownloadConditions(allowsCellularAccess: false, allowsBackgroundDownloading: true)
    private var removedAdvices: [AdviceEntity] = []
    private var removedCount = 0
    
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
        let urlString = "https://api.adviceslip.com/advice"
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            return
        }
        
        let dispatchGroup = DispatchGroup()
        
        for _ in 0..<count {
            let request = URLRequest(url: url)
            
            dispatchGroup.enter()
            
            let task = URLSession.shared.dataTask(with: request) { [weak self] (data, response, error) in
                defer { dispatchGroup.leave() }
                
                guard let self else { return }
                
                if let error = error {
                    print("Error: \(error)")
                    return
                }
                
                guard let httpResponse = response as? HTTPURLResponse, (200..<300).contains(httpResponse.statusCode) else {
                    print("Invalid response or status code")
                    return
                }
                
                guard let data = data else {
                    print("No data")
                    return
                }
                
                do {
                    let response = try JSONDecoder().decode(AdviceDTO.self, from: data)
                    let advice = response.slip.convertToEntity()
                    
                    englishKoreanTranslator.translate(advice.content) { translatedText, error in
                        if let error = error {
                            print("Translation error: \(error)")
                        } else {
                            let updatedAdvice = AdviceEntity(id: advice.id, content: advice.content, adviceKorean: translatedText)
                            self.saveAdviceEntity(adviceEntity: updatedAdvice, context: context)
                            result.append(updatedAdvice)
                        }
                    }
                    
                } catch {
                    print("Error decoding JSON: \(error)")
                }
            }
            task.resume()
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
    func toggleBookmark(id: Int, at index: Int, advice: AdviceEntity, context: NSManagedObjectContext) {
        advices[index].isBookmarked.toggle()
        updateAdviceStatus(for: id, to: advices[index].isBookmarked, context: context)
        updateBookmark(adviceEntity: advice, context: context)
    }

    // 코어데이터 북마크 값 수정
    func updateAdviceStatus(for id: Int, to isBookmarked: Bool, context: NSManagedObjectContext) {
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
    
    // 북마크한 명언을 코어데이터에 저장
    func updateBookmark(adviceEntity: AdviceEntity, context: NSManagedObjectContext) {
        let duplicateRequest: NSFetchRequest<CDBookmark> = CDBookmark.fetchRequest()
        duplicateRequest.predicate = NSPredicate(format: "id == %d", adviceEntity.id)

        do {
            let existingEntities = try context.fetch(duplicateRequest)

            if existingEntities.isEmpty {
                let cdBookmark = CDBookmark(context: context)
                cdBookmark.update(from: adviceEntity, context: context)
                
                try context.save()
            } else {
                for entity in existingEntities {
                    context.delete(entity)
                }
                try context.save()
            }
        } catch {
            print("CDBookmark 데이터 업데이트 실패: \(error)")
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
