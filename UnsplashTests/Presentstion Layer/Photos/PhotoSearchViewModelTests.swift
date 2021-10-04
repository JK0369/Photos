//
//  PhotoSearchViewModelTests.swift
//  UnsplashTests
//
//  Created by 김종권 on 2021/10/04.
//

import XCTest
@testable import Unsplash

class PhotoSearchViewModelTests: XCTestCase {
    static let photos: [Photo] = {
        let photo1 = Photo(image: .placeholderImage, imageUrl: URL(string: "https://test-1.com/")!, username: "username1")
        return [photo1]
    }()

    struct PhotoSearchUseCaseMock: PhotoSearchUseCase {
        func execute(requestVal: PhotoSearchRequestValue, completion: @escaping (Result<[Photo], Error>) -> Void) {
            completion(.success(PhotoSearchViewModelTests.photos))
        }
    }

    struct ImageCacheMock: ImageCachable {
        func loadImage(for item: Item, completion: @escaping ImageCompletion) {
            guard let photo = PhotoSearchViewModelTests.photos.first else { return }
            completion(photo, UIImage.placeholderImage)
        }
        func prefetchImage(for item: Item) {}
        func reset() {}
    }

    static func showPhotoDetailMock(_ photos: [Photo], _ indexPath: IndexPath) {}

    func test_whenPhotoSearchUseCaseRetrievesTwoPage_thenViewModelAddingCurrentPageTwo() {
        // given
        let photoSearchUseCaseMock = PhotoSearchUseCaseMock()
        let expectation = expectation(description: "add current page")
        let imageCacheMock = ImageCacheMock()
        let photoSearchViewModelActionsMock = PhotoSearchViewModelActions(showPhotoDetail: PhotoSearchViewModelTests.showPhotoDetailMock)
        let viewModel = PhotoSearchViewModelImpl(photoSearchUseCase: photoSearchUseCaseMock, imageCache: imageCacheMock, actions: photoSearchViewModelActionsMock)
        let collectionViewMock = UICollectionView(frame: .zero, collectionViewLayout: .leftThreeRightThree)

        // when (input)
        viewModel.viewDidLoad(with: collectionViewMock)
        viewModel.didTapReuturnKey(with: "query-test")
        viewModel.scrollViewDidScroll()

        // then (output)
        XCTAssertTrue(viewModel.currentPage == 2)
        expectation.fulfill()

        waitForExpectations(timeout: 3, handler: nil)
    }

}
