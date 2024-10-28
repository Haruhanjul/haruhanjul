//
//  BaseURL.swift
//  NetworkKit
//
//  Created by 최하늘 on 10/25/24.
//

import Foundation

internal import Alamofire

public enum BaseURL: String {
    case adviceslip
    
    public var configValue: String {
        if let infoDictionary: [String: Any] = Bundle.main.infoDictionary,
           let baseURL = infoDictionary[self.rawValue] as? String {
            return baseURL.decodeURL()
        } else {
            return "https://api.adviceslip.com/advice"
        }
    }
}

extension String {
    func decodeURL() -> String {
        var urlDecodedString = self.removingPercentEncoding ?? .init()
        
        if urlDecodedString == "" {
            urlDecodedString = self
            urlDecodedString = urlDecodedString.replacingOccurrences(of: "%3A%2F%2", with: "://")
            urlDecodedString = urlDecodedString.replacingOccurrences(of: "%26", with: "&")
            urlDecodedString = urlDecodedString.replacingOccurrences(of: "%2F", with: "/")
            urlDecodedString = urlDecodedString.replacingOccurrences(of: "%3A", with: ":")
            urlDecodedString = urlDecodedString.replacingOccurrences(of: "%3F", with: "?")
            urlDecodedString = urlDecodedString.replacingOccurrences(of: "%3D", with: "=")
        }
        
        return urlDecodedString
    }
}
