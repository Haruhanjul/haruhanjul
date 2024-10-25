//
//  Requestable.swift
//  NetworkKit
//
//  Created by 최하늘 on 10/25/24.
//

import Foundation

import Alamofire

typealias HTTPRequestParameter = [String: Any]

protocol Requestable {
    
    associatedtype Response: Decodable
    
    var baseURL: String { get }
    var serverVersion: String { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var headers: HTTPHeaders { get }
    var parameters: HTTPRequestParameter? { get }
    var encoding: ParameterEncoding { get }
    
}
