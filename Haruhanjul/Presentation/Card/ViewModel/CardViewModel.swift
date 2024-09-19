//
//  CardViewModel.swift
//  Haruhanjul
//
//  Created by 임대진 on 9/5/24.
//

import Foundation
import MLKitTranslate

final class CardViewModel: ObservableObject {
    @Published var advices: [AdviceEntity] = []
    @Published var isLoading: Bool = false
    
    private let englishKoreanTranslator = Translator.translator(options: TranslatorOptions(sourceLanguage: .english, targetLanguage: .korean))
    private let conditions = ModelDownloadConditions(
        allowsCellularAccess: false,
        allowsBackgroundDownloading: true
    )
    
    init() {
        self.englishKoreanTranslator.downloadModelIfNeeded(with: conditions) { error in
            if let error = error {
                print("Error downloading model: \(error)")
            }
        }
    }
    
    func loadAdvices(count: Int) {
        let urlString = "https://api.adviceslip.com/advice"
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            return
        }
        
        self.isLoading = true
        
        let dispatchGroup = DispatchGroup()
        
        for _ in 0..<count {
            let request = URLRequest(url: url)
            
            dispatchGroup.enter()
            
            let task = URLSession.shared.dataTask(with: request) { [weak self] (data, response, error) in
                defer { dispatchGroup.leave() }
                
                guard let self = self else { return }
                
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
                    
                    translateToKorean(advice) { translatedText in
                        var updatedAdvice = advice
                        updatedAdvice.adviceKorean = translatedText
                        
                        DispatchQueue.main.async { [weak self] in
                            guard let self else { return }
                            advices.append(updatedAdvice)
                        }
                    }
                } catch {
                    print("Error decoding JSON: \(error)")
                }
            }
            task.resume()
        }
        
        dispatchGroup.notify(queue: .main) {
            self.isLoading = false
        }
    }
    
    private func translateToKorean(_ advice: AdviceEntity, completion: @escaping (String) -> Void) {
        self.englishKoreanTranslator.translate(advice.content) { translatedText, error in
            if let error = error {
                print("Translation error: \(error)")
                completion("")
            } else {
                completion(translatedText ?? "")
            }
        }
    }
}
