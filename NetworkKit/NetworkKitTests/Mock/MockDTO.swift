//
//  MockDTO.swift
//  NetworkKit
//
//  Created by 최하늘 on 10/28/24.
//

import Foundation

struct MockDTO {
    
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
    }
}
