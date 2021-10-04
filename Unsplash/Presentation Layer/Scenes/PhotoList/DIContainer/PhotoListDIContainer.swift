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
        let imageCache: ImageCachable
    }

    private let dependencies: Dependencies
    weak var photoListViewModel: PhotoListViewModel?

    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }

    func makePhotoListViewController(actions: PhotoListViewModelActions) -> UIViewController {
        let photoListViewModel = makePhotoListViewModel(actions: actions)
        let photoListViewController = PhotoListViewController.create(with: photoListViewModel)
        self.photoListViewModel = photoListViewModel

        return photoListViewController
    }

    func makePhotoListCoordinator(navigationController: UINavigationController) -> PhotoListCoordinator {
        return PhotoListCoordinator(navigationConroller: navigationController, dependencies: self)
    }

    // DIContainers of scenes

    func makePhotoDetailDIContainer(photos: [Photo], selectedIndexPath: IndexPath) -> PhotoDetailDIContainer {
        return PhotoDetailDIContainer(dependencies: .init(photos: photos, selectedIndexPath: selectedIndexPath))
    }

    // Private

    private func makePhotoListRepository() -> PhotoListRepository {
        return PhotoListRepositoryImpl(provider: dependencies.provider)
    }

    private func makePhotoListUseCase() -> PhotoListUseCase {
        return PhotoListUseCaseImpl(photoListRepository: makePhotoListRepository())
    }

    private func makePhotoListViewModel(actions: PhotoListViewModelActions) -> PhotoListViewModel {
        return PhotoListViewModelImpl(photoListUseCase: makePhotoListUseCase(), imageCache: dependencies.imageCache, actions: actions)
    }

}

extension PhotoListDIContainer: PhotoListCoordinatorDependencies {
    func makePhotoDetailViewController(photos: [Photo], selectedIndexPath: IndexPath) -> UIViewController {
        let photoDetailDIContainer = makePhotoDetailDIContainer(photos: photos, selectedIndexPath: selectedIndexPath)

        // photoListViewModel 주입 이유: `photoDetailViewModel.delegate = photoListViewModel` 하기위해 주입
        return photoDetailDIContainer.makePhotoDetailViewController(with: photoListViewModel)
    }
}
