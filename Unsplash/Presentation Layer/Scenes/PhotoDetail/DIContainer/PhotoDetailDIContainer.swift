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

    func makePhotoDetailViewController(with delegateConformableViewModel: PhotoDetailViewModelDelegate?) -> PhotoDetailViewController {
        return PhotoDetailViewController.create(with: makeDetailViewModel(with: delegateConformableViewModel))
    }

    // Private

    private func makeDetailViewModel(with delegateConformableViewModel: PhotoDetailViewModelDelegate?) -> PhotoDetailViewModel {
        let photoDetailViewModel = PhotoDetailViewModelImpl(photos: dependencies.photos, selectedIndexPath: dependencies.selectedIndexPath)
        if let delegateConformableViewModel = delegateConformableViewModel {
            photoDetailViewModel.delegate = delegateConformableViewModel
        }
        return photoDetailViewModel
    }
}
