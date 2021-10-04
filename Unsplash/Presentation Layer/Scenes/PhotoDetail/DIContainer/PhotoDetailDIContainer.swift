//
//  PhotoDetailDIContainer.swift
//  Unsplash
//
//  Created by 김종권 on 2021/10/03.
//

import Foundation
import UIKit

class PhotoDetailDIContainer {
    struct Dependencies {
        let photos: [Photo]
        let selectedIndexPath: IndexPath
    }

    private let dependencies: Dependencies

    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }

    func makePhotoDetailViewController(with photoListViewModel: PhotoListViewModel?) -> PhotoDetailViewController {
        return PhotoDetailViewController.create(with: makeDetailViewModel(with: photoListViewModel))
    }

    // Private

    private func makeDetailViewModel(with photoListViewModel: PhotoListViewModel?) -> PhotoDetailViewModel {
        let photoDetailViewModel = PhotoDetailViewModelImpl(photos: dependencies.photos, selectedIndexPath: dependencies.selectedIndexPath)
        if let photoListViewModel = photoListViewModel {
            photoDetailViewModel.delegate = photoListViewModel
        }
        return photoDetailViewModel
    }
}
