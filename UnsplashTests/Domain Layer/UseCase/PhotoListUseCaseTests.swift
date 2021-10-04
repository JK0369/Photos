//
//  PhotoListUseCaseTests.swift
//  UnsplashTests
//
//  Created by 김종권 on 2021/10/04.
//

import XCTest
@testable import Unsplash

class PhotoListUseCaseTests: XCTestCase {
    static let photos: [Photo] = {
        let photo1 = Photo(image: .placeholderImage, imageUrl: URL(string: "https://test-1.com/")!, username: "username1")
        let photo2 = Photo(image: .placeholderImage, imageUrl: URL(string: "https://test-2.com/")!, username: "username2")
        let photo3 = Photo(image: .placeholderImage, imageUrl: URL(string: "https://test-3.com/")!, username: "username3")
        let photo4 = Photo(image: .placeholderImage, imageUrl: URL(string: "https://test-4.com/")!, username: "username4")
        return [photo1, photo2, photo3, photo4]
    }()

    struct PhotoListRepositoryMock: PhotoListRepository {
        func fetchPhotoList(page: Int, completion: @escaping (Result<[Photo], Error>) -> Void) {
            completion(.success(PhotoListUseCaseTests.photos))
        }
    }

    func testPhotoListUseCase_whenSuccessfullyFetchesPhotos_thanReutrnProperResponse() {
        // given
        let expectation = expectation(description: "return proper resopnse")
        let photoListRepository = PhotoListRepositoryMock()
        let useCase = PhotoListUseCaseImpl(photoListRepository: photoListRepository)
        let expectationPhotosFirstImageUrl = URL(string: "https://test-1.com/")!

        // when
        let requestValue = PhotoListRequestValue(page: 1)
        useCase.execute(requestVal: requestValue) { result in
            switch result {
            case .success(let photos):

                // then
                XCTAssertEqual(expectationPhotosFirstImageUrl, photos.first?.imageUrl)
                expectation.fulfill()
                
            case .failure:
                XCTFail()
            }
        }

        waitForExpectations(timeout: 3, handler: nil)
    }
}
