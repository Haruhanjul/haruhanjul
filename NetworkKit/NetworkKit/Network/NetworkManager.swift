//
//  NetworkManager.swift
//  NetworkKit
//
//  Created by 최하늘 on 10/25/24.
//

import Foundation
import Combine
internal import Alamofire

final class NetworkManager: Network {
    var session: Session
    
    init(session: Session = .default) {
        self.session = session
    }
    
    func request<E: Requestable>(with endpoint: E) -> AnyPublisher<E.Response, Error> {
        Future { [weak self] promise in
            guard let self = self else {
                return promise(.failure(NSError(domain: "Network Error", code: -1, userInfo: nil)))
            }
            
            self.session.request(endpoint.baseURL,
                                 method: endpoint.method,
                                 parameters: endpoint.parameters,
                                 encoding: endpoint.encoding,
                                 headers: endpoint.headers)
            .validate()
            .responseDecodable(of: E.Response.self) { response in
                switch response.result {
                case .success(let data):
                    promise(.success(data))
                case .failure(let error):
                    promise(.failure(error))
                }
            }
        }
        .eraseToAnyPublisher()
    }
}
