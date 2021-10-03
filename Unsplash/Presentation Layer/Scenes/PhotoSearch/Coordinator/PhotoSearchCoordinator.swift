//
//  PhotoSearchCoordinator.swift
//  Unsplash
//
//  Created by 김종권 on 2021/10/03.
//

import UIKit

protocol PhotoSearchCoordinatorDependencies {
    func makePhotoDetailViewController(photos: [Photo], selectedIndexPath: IndexPath) -> UIViewController
}

class PhotoSearchCoordinator {
    private weak var navigationConroller: UINavigationController?
    private let dependencies: PhotoSearchCoordinatorDependencies

    init(navigationConroller: UINavigationController, dependencies: PhotoSearchCoordinatorDependencies) {
        self.navigationConroller = navigationConroller
        self.dependencies = dependencies
    }

    func showPhotoDetail(photos: [Photo], selectedIndexPath: IndexPath) {
        let photoDetailViewController = dependencies.makePhotoDetailViewController(photos: photos, selectedIndexPath: selectedIndexPath)
        navigationConroller?.pushViewController(photoDetailViewController, animated: true)
    }
}
