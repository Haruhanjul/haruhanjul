//
//  APIEventMonitor.swift
//  NetworkKit
//
//  Created by 최하늘 on 10/28/24.
//

import Foundation

internal import Alamofire

final class APIEventMonitor: EventMonitor {

    public let queue = DispatchQueue(label: "APIEventMonitor")
    
    public init() { }

    public func requestDidFinish(_ request: Request) {
        
        debugPrint("""
        📱 NETWORK Reqeust LOG
        📱 URL: \(request.request?.url?.absoluteString ?? "")
        📱 Method: \(request.request?.httpMethod ?? "")
        📱 Headers: \(request.request?.allHTTPHeaderFields ?? [:])
        📱 AccessToken: \(request.request?.headers["X-Access-Token"] ?? "")
        📱 Body: \(request.request?.httpBody?.toPrettyPrintedString ?? "")

        ------------------------------------------------------------------------
        """)
    }

    public func request<Value>(_ request: DataRequest, didParseResponse response: DataResponse<Value, AFError>) {
        
        debugPrint("""
        📲 NETWORK Response LOG
        📲 URL: \(request.request?.url?.absoluteString ?? "")
        📲 Result: \(response.result)
        📲 StatusCode: \(response.response?.statusCode ?? 0)
        📲 Data: \(response.data?.toPrettyPrintedString ?? "")

        """)
    }
}

extension Data {
    
    public var toPrettyPrintedString: String? {
        guard let object = try? JSONSerialization.jsonObject(with: self, options: []),
              let data = try? JSONSerialization.data(withJSONObject: object, options: [.prettyPrinted]),
              let prettyPrintedString = NSString(data: data, encoding: String.Encoding.utf8.rawValue) else { return nil }
        return prettyPrintedString as String
    }
}
