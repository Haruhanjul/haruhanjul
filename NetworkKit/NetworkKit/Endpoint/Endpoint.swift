//
//  Endpoint.swift
//  NetworkKit
//
//  Created by 최하늘 on 10/25/24.
//

import Foundation

import Alamofire

struct Endpoint<R>: Requestable where R: Decodable {
    typealias Response = R
    
    let baseURL: String
    let path: String
    let method: HTTPMethod
    let headers: HTTPHeaders
    let parameters: HTTPRequestParameter?
    
    init(
        baseURL: BaseURL,
        path: String,
        method: HTTPMethod,
        parameters: HTTPRequestParameter? = nil
    ) {
        self.headers = ["Content-Type": "application/json"]
        self.baseURL = baseURL.configValue
        self.path = path
        self.method = method
        self.parameters = parameters
    }
}

