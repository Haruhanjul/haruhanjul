//
//  Advice.swift
//  Haruhanjul
//
//  Created by 임대진 on 9/12/24.
//

import Foundation

struct AdviceResponse: Codable {
    let slip: Advice
}

struct Advice: Codable {
    let id: Int
    var advice: String
    var adviceKorean: String?
}
