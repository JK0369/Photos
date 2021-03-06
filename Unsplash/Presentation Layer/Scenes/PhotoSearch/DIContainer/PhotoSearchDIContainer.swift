//
//  PhotoSearchDIContainer.swift
//  Unsplash
//
//  Created by 김종권 on 2021/10/03.
//

import Foundation
import UIKit

class PhotoSearchDIContainer {

    struct Dependencies {
        let provider: Provider
        let imageCache: ImageCachable
    }

    private let dependencies: Dependencies
    weak var photoSearchViewModel: PhotoSearchViewModel?

    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }

    func makePhotoSearchViewController(actions: PhotoSearchViewModelActions) -> UIViewController {
        let photoSearchViewModel = makePhotoSearchViewModel(actions: actions)
        let photoSearchViewController = PhotoSearchViewController.create(with: photoSearchViewModel)
        self.photoSearchViewModel = photoSearchViewModel

        return photoSearchViewController
    }

    func makePhotoSearchCoordinator(navigationController: UINavigationController) -> PhotoSearchCoordinator {
        return PhotoSearchCoordinator(navigationConroller: navigationController, dependencies: self)
    }

    // DIContainers of scenes

    private func makePhotoDetailDIContainer(photos: [Photo], selectedIndexPath: IndexPath) -> PhotoDetailDIContainer {
        return PhotoDetailDIContainer(dependencies: .init(photos: photos, selectedIndexPath: selectedIndexPath))
    }

    // Private

    private func makePhotoSearchRepository() -> PhotoSearchRepository {
        return PhotoSearchRepositoryImpl(provider: dependencies.provider)
    }

    private func makePhotoSearchUseCase() -> PhotoSearchUseCase {
        return PhotoSearchUseCaseImpl(photoSearchRepository: makePhotoSearchRepository())
    }

    private func makePhotoSearchViewModel(actions: PhotoSearchViewModelActions) -> PhotoSearchViewModel {
        return PhotoSearchViewModelImpl(photoSearchUseCase: makePhotoSearchUseCase(), imageCache: dependencies.imageCache, actions: actions)
    }

}

extension PhotoSearchDIContainer: PhotoSearchCoordinatorDependencies {
    func makePhotoDetailViewController(photos: [Photo], selectedIndexPath: IndexPath) -> UIViewController {
        let photoDetailDIContainer = makePhotoDetailDIContainer(photos: photos, selectedIndexPath: selectedIndexPath)

        return photoDetailDIContainer.makePhotoDetailViewController(with: photoSearchViewModel)
    }
}
