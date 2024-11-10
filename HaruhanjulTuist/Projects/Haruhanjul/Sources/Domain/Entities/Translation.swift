//
//  Translation.swift
//  Haruhanjul
//
//  Created by 임대진 on 9/12/24.
//

import Foundation

struct TranslationResponse: Codable {
    let translations: [Translation]
}

struct Translation: Codable {
    let detected_source_language: String
    let text: String
}
