//
//  NetworkKitTests.swift
//  NetworkKitTests
//
//  Created by 최하늘 on 10/26/24.
//

import XCTest
@testable import NetworkKit

internal import Alamofire
import Combine

final class NetworkKitTests: XCTestCase {
    
    var sut: NetworkManager!
    
    private var cancellables = Set<AnyCancellable>()
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        sut = NetworkManager(session: Session(eventMonitors: [APIEventMonitor()]))
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        sut = nil
    }
    
    func test_네트워크_응답결과_200() throws {
        // given
        let endpoint = MockEndpoint.getAdviceSlip()
        
        // when
        let expectation = self.expectation(description: "Fetching advice")
        
        sut.request(with: endpoint)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    // Test succeeds
                    expectation.fulfill()
                case .failure(let error):
                    XCTFail("🚨 Request failed with error: \(error)")
                }
            }, receiveValue: { response in
                // then
                XCTAssertNotNil(response, "Response should not be nil")
                // 응답 데이터 검증
                print("✅ Received response: \(response)")
                print("✅ Advice ID: \(response.slip.id)")
                print("✅ Advice: \(response.slip.content)")
            })
            .store(in: &cancellables)
        
        waitForExpectations(timeout: 5, handler: nil)
    }
}
