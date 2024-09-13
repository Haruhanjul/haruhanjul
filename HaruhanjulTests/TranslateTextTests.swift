//
//  TranslateTextTests.swift
//  HaruhanjulTests
//
//  Created by 최하늘 on 9/10/24.
//

import XCTest
@testable import Haruhanjul

final class TranslateTextTests: XCTestCase {
    var viewModel: CardViewModel!
    
    override func setUpWithError() throws {
        viewModel = CardViewModel()
    }
    
    override func tearDownWithError() throws {
        viewModel = nil
    }
    
    func test_TranslateText() throws {
        // given: 테스트할 텍스트
        let testTexts = ["Hello", "Goodbye", "Thank you"]
        viewModel.advices = testTexts.enumerated().map { Advice(id: $0.offset, advice: $0.element) }
        
        // when: translateText 메소드 호출
        let expectation = XCTestExpectation(description: "Translate text completion")
        
        viewModel.translateText(texts: testTexts) {
            expectation.fulfill() // 비동기 작업이 끝나면 fulfill을 호출하여 완료를 알림
        }
        
        // then: 비동기 작업이 완료될 때까지 기다린 후 결과
        wait(for: [expectation], timeout: 5.0) // 최대 5초 대기
        
        // Translated texts 확인
        for advice in viewModel.advices {
            print("Translated content: \(advice.advice)")
        }
        
        XCTAssertEqual("안녕하세요", viewModel.advices[0].advice, "\(testTexts[0]) 은/는 \"안녕하세요\" 로 번역되어야 합니다")
    }
}
