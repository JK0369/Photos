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
        let photo2 = Photo(image: .placeholderImage, imageUrl: URL(string: "https://test-2.com/")!, username: "username2")
        let photo3 = Photo(image: .placeholderImage, imageUrl: URL(string: "https://test-3.com/")!, username: "username3")
        let photo4 = Photo(image: .placeholderImage, imageUrl: URL(string: "https://test-4.com/")!, username: "username4")
        return [photo1, photo2, photo3, photo4]
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
        let tableViewMock = UITableView()

        // when (input)
        viewModel.viewDidLoad(with: tableViewMock)
        viewModel.scrollViewDidScroll()

        // then (output)
        XCTAssertTrue(viewModel.currentPage == 2)
        expectation.fulfill()

        waitForExpectations(timeout: 3, handler: nil)
    }
}
