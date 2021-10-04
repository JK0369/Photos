//
//  PhotoListAPITests.swift
//  UnsplashTests
//
//  Created by 김종권 on 2021/10/04.
//

import XCTest
@testable import Unsplash

class PhotoListAPITests: XCTestCase {

    var sut: Provider!

    override func setUpWithError() throws {
        sut = ProviderImpl(session: PhotoListURLSessionMock())
    }

    func test_whenMockDataPassed_thenReutrnProperResponse() {
        let expectation = XCTestExpectation()

        let endpoint = APIEndpoints.getPhotosInfo(with: .init(page: 1))
        let responseMock = try? JSONDecoder().decode([PhotoListResponseDTO].self, from: endpoint.sampleData!)

        sut.request(with: endpoint) { result in
            switch result {
            case .success(let response):
                XCTAssertEqual(response.first?.id, responseMock?.first?.id)
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

        let endpoint = APIEndpoints.getPhotosInfo(with: .init(page: 1))

        sut.request(with: endpoint) { result in
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
