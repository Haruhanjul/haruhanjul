//
//  AdviceEntity.swift
//  Haruhanjul
//
//  Created by 임대진 on 9/12/24.
//

import Foundation

struct AdviceResponse: Codable {
    let slip: AdviceEntity
}

struct AdviceEntity: Codable {
    let id: Int
    var content: String
    var adviceKorean: String?
}

enum Advice {
    @UserDefault(key: "adviceKey", defaultValue: "")
    static var content: String
}
