//
//  AdviceSlip.swift
//  Haruhanjul
//
//  Created by 임대진 on 9/12/24.
//

import Foundation

struct AdviceDTO: Codable {
    let slip: AdviceSlip
}

struct AdviceSlip: Codable {
    let id: Int
    var content: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case content = "advice"
    }
    
    func convertToEntity() -> AdviceEntity {
        return AdviceEntity(
            id: id,
            content: content,
            adviceKorean: nil
        )
    }
}
