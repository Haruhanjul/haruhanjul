//
//  UserDefault.swift
//  Haruhanjul
//
//  Created by 최하늘 on 9/13/24.
//

import Foundation

enum AdviceDefaults {
    @UserDefault(key: "adviceKey", defaultValue: [""])
    static var content: [String]
    
    @UserDefault(key: "lastDay", defaultValue: Date())
    static var day: Date
    
    @UserDefault(key: "cardIndex", defaultValue: 0)
    static var cardIndex: Int
}

@propertyWrapper
struct UserDefault<T> {
    let key: String
    let defaultValue: T
    let groupName: String? = "group.daeha.Haruhanjul"

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
