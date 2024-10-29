//
//  MockEndpoint.swift
//  NetworkKit
//
//  Created by 최하늘 on 10/28/24.
//

import Foundation

internal import NetworkKit

enum MockEndpoint {
    
    static func getAdviceSlip() -> Endpoint<MockDTO.AdviceDTO> {
        return Endpoint(
            baseURL: .adviceslipAPI,
            path: "/advice",
            method: .get
        )
    }
}
