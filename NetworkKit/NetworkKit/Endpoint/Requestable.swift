//
//  Requestable.swift
//  NetworkKit
//
//  Created by 최하늘 on 10/25/24.
//

import Foundation

public import Alamofire

public typealias HTTPRequestParameter = [String: Any]

public protocol Requestable {
    
    associatedtype Response: Decodable
    
    var baseURL: String { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var headers: HTTPHeaders { get }
    var parameters: HTTPRequestParameter? { get }
    var encoding: ParameterEncoding { get }
    
    func makeURL() -> String
}

public extension Requestable {
    
    var encoding: ParameterEncoding {
        switch method {
            case .post:
                return JSONEncoding.default
            default:
                return URLEncoding.default
        }
    }
    
    func makeURL() -> String {
        return "\(baseURL)\(path)"
    }
}
