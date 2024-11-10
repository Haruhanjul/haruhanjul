//
//  Endpoint.swift
//  NetworkKit
//
//  Created by 최하늘 on 10/25/24.
//

import Foundation

public import Alamofire

public struct Endpoint<R>: Requestable where R: Decodable {
    public typealias Response = R
    
    public let baseURL: String
    public let path: String
    public let method: HTTPMethod
    public let headers: HTTPHeaders
    public let parameters: HTTPRequestParameter?
    
    
    public init(
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

