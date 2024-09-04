//
//  CardViewModel.swift
//  Haruhanjul
//
//  Created by 임대진 on 9/5/24.
//

import Foundation

struct Slip: Codable {
    let slip: SlipResponse
}

struct SlipResponse: Codable {
    let id: Int
    let advice: String
}

final class CardViewModel: ObservableObject {
    @Published var advices: [Slip] = [Slip]()
    @Published var dragProgresses: [CGFloat] = []
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
            
            let task = session.dataTask(with: request) { (data, response, error) in
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
                            let advice = try JSONDecoder().decode(Slip.self, from: data)
                            self.advices.append(advice)
                            self.dragProgresses.append(0)
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
            print("명언 \(count)개 중 \(self.advices.count)개 불러오기 완료.")
            self.isLoading = false
        }
    }
}
