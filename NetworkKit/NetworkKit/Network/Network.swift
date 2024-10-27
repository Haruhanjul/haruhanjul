//
//  Network.swift
//  NetworkKit
//
//  Created by 최하늘 on 10/25/24.
//

import Foundation
import Combine

internal import Alamofire

protocol Network {
    var session: Session { get }
    
    func request<E: Requestable>(with endpoint: E) -> AnyPublisher<E.Response, Error>
}
