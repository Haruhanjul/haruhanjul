//
//  AdviceEntity.swift
//  Haruhanjul
//
//  Created by 최하늘 on 9/19/24.
//

import Foundation

struct AdviceEntity: Codable {
    let uuid: String = UUID().uuidString
    let id: Int
    let slipId: Int
    let content: String
    var adviceKorean: String?
}
