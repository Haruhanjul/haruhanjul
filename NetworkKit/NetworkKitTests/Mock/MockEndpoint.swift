//
//  MockEndpoint.swift
//  NetworkKit
//
//  Created by 최하늘 on 10/28/24.
//

import Foundation
import NetworkKit

enum MockEndpoint {
    
    static func getAdviceSlip() -> Endpoint<MockDTO.AdviceDTO> {
        return Endpoint(
            baseURL: .adviceslip,
            path: "",
            method: .get
        )
    }
}
