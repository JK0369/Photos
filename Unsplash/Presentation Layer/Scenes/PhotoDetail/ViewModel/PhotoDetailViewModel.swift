//
//  PhotoDetailViewModel.swift
//  Unsplash
//
//  Created by 김종권 on 2021/10/03.
//

import Foundation

protocol PhotoDetailViewModelInout {
    func viewDidLoad()
}

protocol PhotoDetailViewModelOutput {
    var currentImage: Observable<([Photo], Int)> { get }
}

protocol PhotoDetailViewModel: PhotoDetailViewModelInout, PhotoDetailViewModelOutput {}

class PhotoDetailViewModelImpl: PhotoDetailViewModel {

    private let photos: [Photo]
    private var selectedIndexPath: IndexPath

    init(photos: [Photo], selectedIndexPath: IndexPath) {
        self.photos = photos
        self.selectedIndexPath = selectedIndexPath
    }

    // Output

    var currentImage: Observable<([Photo], Int)> = .init(([], 0))

    // Input

    func viewDidLoad() {
        currentImage.value = (photos, selectedIndexPath.row)
    }
}
