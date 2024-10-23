//
//  UserDefault.swift
//  Haruhanjul
//
//  Created by 최하늘 on 9/13/24.
//

import Foundation

enum AdviceDefaults {
    static let defaultText = "새로운 하루 한줄을 만나보세요"
    
    @UserDefault(key: "adviceKey", defaultValue: [""])
    static var content: [String]
    
    @UserDefault(key: "cardIndex", defaultValue: 0)
    static var cardIndex: Int
    
    static var firstAdvice: String {
        return content.first ?? defaultText
    }
}

@propertyWrapper
struct UserDefault<T> {
    let key: String
    let defaultValue: T
    let groupName: String? = "group.com.daehaa.Haruhanjul"

    var wrappedValue: T {
        get {
            let defaults = UserDefaults(suiteName: groupName) ?? .standard
            return defaults.object(forKey: key) as? T ?? defaultValue
        }
        set {
            let defaults = UserDefaults(suiteName: groupName) ?? .standard
            defaults.set(newValue, forKey: key)
        }
    }
}
