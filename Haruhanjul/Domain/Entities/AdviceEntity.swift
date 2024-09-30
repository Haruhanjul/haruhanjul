//
//  AdviceEntity.swift
//  Haruhanjul
//
//  Created by 최하늘 on 9/19/24.
//

import Foundation

struct AdviceEntity: Codable, Equatable {
    let id: Int
    let content: String
    var adviceKorean: String?
}
