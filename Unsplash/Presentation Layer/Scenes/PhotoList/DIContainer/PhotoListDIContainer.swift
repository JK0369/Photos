//
//  PhotoListDIContainer.swift
//  Unsplash
//
//  Created by 김종권 on 2021/09/29.
//

import Foundation
import UIKit

class PhotoListDIContainer {

    struct Dependencies {
        // TODO: network dependency
        // TODO: disk cache
    }

    private let dependencies: Dependencies

    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }

    func makePhotoCoordinator() -> PhotoListCoordinator {
        return PhotoListCoordinator(dependencies: self)
    }

    // Private

    private func makePhotoListRepository() -> PhotoListRepository {
        return PhotoListRepositoryImpl()
    }

    private func makePhotoListUseCase() -> PhotoUseCase {
        return PhotoListUseCase(photoListRepository: makePhotoListRepository())
    }

    private func makePhotoListViewModel() -> PhotoViewModel {
        return PhotoViewModelImpl(photoListUseCase: makePhotoListUseCase())
    }

}

extension PhotoListDIContainer: PhotoListCoordinatorDependencies {
    func makePhotoListViewController() -> UIViewController {
        return PhotoListViewController.create(with: makePhotoListViewModel())
    }
}
