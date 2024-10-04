//
//  CardViewModel.swift
//  Haruhanjul
//
//  Created by 임대진 on 9/5/24.
//

import Foundation
//import MLKitTranslate
import CoreData

final class CardViewModel: ObservableObject {
//    private let englishKoreanTranslator = Translator.translator(options: TranslatorOptions(sourceLanguage: .english, targetLanguage: .korean))
//    private let conditions = ModelDownloadConditions(allowsCellularAccess: false, allowsBackgroundDownloading: true)
    var isTranslatorReady = false

    func downloadTranslatorModel() async {
//        print("언어 모델 다운로드 시작")
//        await withCheckedContinuation { continuation in
//            self.englishKoreanTranslator.downloadModelIfNeeded(with: conditions) { error in
//                guard error == nil else {
//                    print("언어 모델 다운로드 실패: \(error!)")
//                    return continuation.resume()
//                }
//                print("언어 모델 다운로드 완료")
//                self.isTranslatorReady = true
//                continuation.resume()
//            }
//        }
    }
    
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
                    
//                    englishKoreanTranslator.translate(advice.content) { translatedText, error in
//                        if let error = error {
//                            print("Translation error: \(error)")
//                        } else {
//                            let updatedAdvice = AdviceEntity(id: advice.id, content: advice.content, adviceKorean: translatedText)
//                            self.saveAdviceEntity(adviceEntity: updatedAdvice, context: context)
//                            result.append(updatedAdvice)
//                        }
//                    }
                    
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
    
    func saveAdviceEntity(adviceEntity: AdviceEntity, context: NSManagedObjectContext) {
        let duplicateRequest: NSFetchRequest<CDAdviceEntity> = CDAdviceEntity.fetchRequest()
        duplicateRequest.predicate = NSPredicate(format: "id == %d", adviceEntity.id)

        do {
            let existingEntities = try context.fetch(duplicateRequest)

            if existingEntities.isEmpty {
                
                let cdAdviceEntity = CDAdviceEntity(context: context)
                cdAdviceEntity.update(from: adviceEntity, context: context)
                
                try context.save()
                print("명언 저장 완료 id: \(cdAdviceEntity.id)")
            } else {
                print("이미 저장된 명언 id: \(adviceEntity.id)")
            }
        } catch {
            print("데이터 저장 실패: \(error)")
        }
    }

    func loadAdviceEntities(context: NSManagedObjectContext, completion: @escaping ([AdviceEntity], Int) -> ()) {
        let fetchRequest: NSFetchRequest<CDAdviceEntity> = CDAdviceEntity.fetchRequest()
        
        do {
            let cdAdviceEntities = try context.fetch(fetchRequest)
            
            completion(cdAdviceEntities.map { $0.toAdviceEntity() }, cdAdviceEntities.count)
        } catch {
            print("데이터 로드 실패: \(error)")
            completion([], 0)
        }
    }
    
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
}
