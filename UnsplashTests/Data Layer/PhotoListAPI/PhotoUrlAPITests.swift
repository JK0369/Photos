//
//  PhotoUrlAPITests.swift
//  UnsplashTests
//
//  Created by 김종권 on 2021/10/04.
//

import XCTest
@testable import Unsplash

class PhotoUrlAPITests: XCTestCase {

    var sut: Provider!

    override func setUpWithError() throws {
        sut = ProviderImpl(session: PhotoListURLSessionMock())
    }

    func test_whenMockDataPassed_thenReutrnProperResponse() {
        let expectation = XCTestExpectation()

        let endpoint = APIEndpoints.getImages(with: "https://testurl.com/")
        let responseMock = endpoint.sampleData!

        sut.request(try! endpoint.url()) { result in
            switch result {
            case .success(let data):
                XCTAssertEqual(data, responseMock)
            case .failure:
                XCTFail()
            }
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 2.0)
    }

    func test_whenResponseStatusCodeFailed_thenReturnStatusErrorCode() {
        sut = ProviderImpl(session: PhotoListURLSessionMock(makeRequestFail: true))
        let expectation = XCTestExpectation()

        let endpoint = APIEndpoints.getImages(with: "https://testurl.com/")

        sut.request(try! endpoint.url()) { result in
            switch result {
            case .success:
                XCTFail()
            case .failure(let error):
                XCTAssertEqual(error.localizedDescription, "status코드가 200~299가 아닙니다.")
            }
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 2.0)
    }
    
}
