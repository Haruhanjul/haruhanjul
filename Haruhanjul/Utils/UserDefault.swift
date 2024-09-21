//
//  UserDefault.swift
//  Haruhanjul
//
//  Created by 최하늘 on 9/13/24.
//

import Foundation

enum AdviceDefaults {
    @UserDefault(key: "adviceKey", defaultValue: "")
    static var content: String
    
    @UserDefault(key: "lastDay", defaultValue: Date())
    static var day: Date
}

@propertyWrapper
struct UserDefault<T> {
    let key: String
    let defaultValue: T
    
    var wrappedValue: T {
        get {
            return UserDefaults.standard.object(forKey: key) as? T ?? defaultValue
        }
        set {
            UserDefaults.standard.set(newValue, forKey: key)
        }
    }
}

