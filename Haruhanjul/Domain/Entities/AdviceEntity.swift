//
//  AdviceEntity.swift
//  Haruhanjul
//
//  Created by 최하늘 on 9/19/24.

import Foundation

struct AdviceEntity: Codable {
    let id: Int
    var content: String
    var adviceKorean: String?
}

struct AdviceResponse: Codable {
    let slip: AdviceEntity
}

enum Advice {
    @UserDefault(key: "adviceKey", defaultValue: "")
    static var content: String
}

