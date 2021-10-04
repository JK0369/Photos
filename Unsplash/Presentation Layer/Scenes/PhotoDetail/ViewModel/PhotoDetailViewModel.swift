//
//  PhotoDetailViewModel.swift
//  Unsplash
//
//  Created by 김종권 on 2021/10/03.
//

import Foundation

protocol PhotoDetailViewModelDelegate: AnyObject {
    func didUpdateScroll(to page: IndexPath)
}

protocol PhotoDetailViewModelInout {
    func viewDidLoad()
    func viewWillAppear()
    func didUpdateScroll(to page: Int)
}

protocol PhotoDetailViewModelOutput {
    var images: Observable<([Photo], Int)> { get }
    var photoTitle: Observable<String> { get }
}

protocol PhotoDetailViewModel: PhotoDetailViewModelInout, PhotoDetailViewModelOutput {}

class PhotoDetailViewModelImpl: PhotoDetailViewModel {

    private let photos: [Photo]
    private var selectedIndexPath: IndexPath
    weak var delegate: PhotoDetailViewModelDelegate?

    init(photos: [Photo], selectedIndexPath: IndexPath) {
        self.photos = photos
        self.selectedIndexPath = selectedIndexPath
    }

    // Output

    var images: Observable<([Photo], Int)> = .init(([], 0))
    var photoTitle: Observable<String> = .init("")

    // Input

    func viewDidLoad() {
        images.value = (photos, selectedIndexPath.row)
    }

    func viewWillAppear() {
        photoTitle.value = photos[selectedIndexPath.row].username
    }

    func didUpdateScroll(to page: Int) {
        photoTitle.value = photos[page].username
        delegate?.didUpdateScroll(to: IndexPath(row: page, section: 0))
    }
}
