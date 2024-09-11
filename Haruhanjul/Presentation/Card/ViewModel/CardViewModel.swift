//
//  CardViewModel.swift
//  Haruhanjul
//
//  Created by 임대진 on 9/5/24.
//

import Foundation
import MLKitTranslate

final class CardViewModel: ObservableObject {
    @Published var advices: [Advice] = [Advice]()
    @Published var isLoading: Bool = false
    
    let englishKoreanTranslator = Translator.translator(options: TranslatorOptions(sourceLanguage: .english, targetLanguage: .korean))
    
    let conditions = ModelDownloadConditions(
        allowsCellularAccess: false, // 셀룰러 허용 여부
        allowsBackgroundDownloading: true // 백그라운드 다운 허용 여부
    )
    
    init() {
        self.englishKoreanTranslator.downloadModelIfNeeded(with: conditions) { error in
            guard error == nil else { return }
        }
    }
    
    func loadAdvices(count: Int) async {
        let urlString = "https://api.adviceslip.com/advice"
        let session = URLSession.shared
        let dispatchGroup = DispatchGroup()
        
        self.isLoading = true
        
        for _ in 0..<count {
            guard let url = URL(string: urlString) else {
                print("Invalid URL")
                return
            }
            
            let request = URLRequest(url: url)
            
            dispatchGroup.enter()
            
            let task = session.dataTask(with: request) { [self] (data, response, error) in
                defer { dispatchGroup.leave() }
                
                guard error == nil else {
                    print("Error: \(error!)")
                    return
                }
                guard let httpResponse = response as? HTTPURLResponse else {
                    print("Invalid httpResponse")
                    return
                }
                
                if (200..<300).contains(httpResponse.statusCode) {
                    if let data = data {
                        do {
                            let response = try JSONDecoder().decode(AdviceResponse.self, from: data)
                            var advice = Advice(id: response.slip.id, advice: response.slip.advice, adviceKorean: "")
                            
                            englishKoreanTranslator.translate(advice.advice) { translatedText, error in
                                guard error == nil, let translatedText else { return }
                                advice.adviceKorean = translatedText
                                self.advices.append(advice)
                            }

                        } catch {
                            print("Error decoding JSON: \(error)")
                        }
                    }
                } else {
                    if let data = data {
                        let responseData = String(data: data, encoding: .utf8)
                        print("\(httpResponse.statusCode) data: \(responseData ?? "No data")")
                    }
                }
            }
            task.resume()
        }
        
        dispatchGroup.notify(queue: .main) {
            self.isLoading = false
        }
    }
}
