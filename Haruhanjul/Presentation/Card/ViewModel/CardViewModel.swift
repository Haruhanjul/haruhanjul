//
//  CardViewModel.swift
//  Haruhanjul
//
//  Created by 임대진 on 9/5/24.
//

import Foundation

struct AdviceResponse: Codable {
    let slip: Advice
}

struct Advice: Codable {
    let id: Int
    var advice: String
}

struct TranslationResponse: Codable {
    let translations: [Translation]
}

struct Translation: Codable {
    let detected_source_language: String
    let text: String
}

final class CardViewModel: ObservableObject {
    @Published var advices: [Advice] = [Advice]()
    @Published var isLoading: Bool = false
    
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
                            let advice = Advice(id: response.slip.id, advice: response.slip.advice)
                            advices.append(advice)
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
            self.translateText(texts: self.advices.map { $0.advice }) {
                print("명언 \(count)개 중 \(self.advices.count)개 불러오기 완료.")
                self.isLoading = false
            }
        }
    }
    
    func translateText(texts: [String], completion: @escaping () -> ()) {
        let urlString = "https://api-free.deepl.com/v2/translate"
        guard let url = URL(string: urlString) else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // 임시 text key
        request.setValue("DeepL-Auth-Key ed5b770f-3009-4054-8982-df95771baf76:fx", forHTTPHeaderField: "Authorization")
        
        let body: [String: Any] = [
            "text": texts,
            "target_lang": "KO",
            "source_lang":"EN"
        ]

        do {
            let jsonData = try JSONSerialization.data(withJSONObject: body, options: [])
            request.httpBody = jsonData
        } catch {
            print("Error serializing JSON: \(error)")
        }
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard error == nil else {
                print("Error: \(error!.localizedDescription)")
                return
            }
            
            guard let data = data else { return }
            
            do {
                let decodedResponse = try JSONDecoder().decode(TranslationResponse.self, from: data)
                
                for (index, text) in decodedResponse.translations.map({ $0.text }).enumerated() {
                    self.advices[index].advice = text
                }
                completion()
            } catch {
                print("Error decoding JSON: \(error)")
            }
        }
        task.resume()
    }

}
