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
        let provider: Provider
    }

    private let dependencies: Dependencies

    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }

    func makePhotoListViewController() -> UIViewController {
        let photoListViewController = PhotoListViewController.create(with: makePhotoListViewModel())
        return photoListViewController
    }

    func makePhotoCoordinator(navigationController: UINavigationController) -> PhotoListCoordinator {
        return PhotoListCoordinator(navigationConroller: navigationController, dependencies: self)
    }

    // Private

    private func makePhotoListRepository() -> PhotoListRepository {
        return PhotoListRepositoryImpl(provider: dependencies.provider)
    }

    private func makePhotoListUseCase() -> PhotoListUseCase {
        return PhotoListUseCaseImpl(photoListRepository: makePhotoListRepository())
    }

    private func makePhotoListViewModel() -> PhotoListViewModel {
        return PhotoListViewModelImpl(photoListUseCase: makePhotoListUseCase())
    }

}

extension PhotoListDIContainer: PhotoListCoordinatorDependencies {
    func makePhotoDetailViewController(photos: [Photo]) -> UIViewController {
        // TODO:

        return UIViewController()
    }
}
