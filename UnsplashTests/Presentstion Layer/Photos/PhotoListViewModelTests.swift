//
//  PhotoListViewModelTests.swift
//  UnsplashTests
//
//  Created by 김종권 on 2021/10/04.
//

import XCTest
@testable import Unsplash

class PhotoListViewModelTests: XCTestCase {
    static let photos: [Photo] = {
        let photo1 = Photo(image: .placeholderImage, imageUrl: URL(string: "https://test-1.com/")!, username: "username1")
        return [photo1]
    }()

    struct PhotoListUseCaseMock: PhotoListUseCase {
        func execute(requestVal: PhotoListRequestValue, completion: @escaping (Result<[Photo], Error>) -> Void) {
            completion(.success(PhotoListViewModelTests.photos))
        }
    }

    struct ImageCacheMock: ImageCachable {
        func loadImage(for item: Item, completion: @escaping ImageCompletion) {
            guard let photo = PhotoListViewModelTests.photos.first else { return }
            completion(photo, UIImage.placeholderImage)
        }
        func prefetchImage(for item: Item) {}
        func reset() {}
    }

    static func showPhotoDetailMock(_ photos: [Photo], _ indexPath: IndexPath) {}

    func test_whenPhotoListUseCaseRetrievesTwoPage_thenViewModelAddingCurrentPageTwo() {
        // given
        let photoListUseCaseMock = PhotoListUseCaseMock()
        let expectation = expectation(description: "add current page")
        let imageCacheMock = ImageCacheMock()
        let photoListViewModelActionsMock = PhotoListViewModelActions(showPhotoDetail: PhotoListViewModelTests.showPhotoDetailMock)
        let viewModel = PhotoListViewModelImpl(photoListUseCase: photoListUseCaseMock,
                                               imageCache: imageCacheMock,
                                               actions: photoListViewModelActionsMock)
        // when (input)
        viewModel.viewDidLoad()
        viewModel.scrollViewDidScroll()

        // then (output)
        XCTAssertTrue(viewModel.currentPage == 2)
        expectation.fulfill()

        waitForExpectations(timeout: 3, handler: nil)
    }
}
