//
//  PhotoListViewModel.swift
//  Unsplash
//
//  Created by 김종권 on 2021/09/29.
//

import Foundation

struct PhotoListViewModelActions {
    let didTapPhoto: (selectedIndex: Int, photos: [Data])
}

protocol PhotoListViewModelInput {
    func viewDidLoad()
    func didSelectRow(at index: Int)
    func didLoadNextPage()
}

protocol PhotoListViewModelOutput {
    var photos: Observable<[Photo]> { get }
}

protocol PhotoListViewModel: PhotoListViewModelInput, PhotoListViewModelOutput {}

class PhotoListViewModelImpl: PhotoListViewModel {
    private let photoListUseCase: PhotoListUseCase

    // TODO: 4개 변수 확실히 알기
    private var currentPage: Int = 0
    private var totalPageCount: Int = 1
    private var hasMorePage: Bool { currentPage < totalPageCount }
    private var nextPage: Int { hasMorePage ? currentPage + 1 : currentPage }

    init(photoListUseCase: PhotoListUseCase) {
        self.photoListUseCase = photoListUseCase
    }

    // Output

    var photos: Observable<[Photo]> = .init([])

    // Input

    func viewDidLoad() {
        // TODO: usecase
    }

    func didLoadNextPage() {
        <#code#>
    }

    func didSelectRow(at index: Int) {
        // TODO:
    }
}
