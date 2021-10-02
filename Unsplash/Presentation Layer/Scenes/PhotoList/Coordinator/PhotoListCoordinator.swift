//
//  PhotoListCoordinator.swift
//  Unsplash
//
//  Created by 김종권 on 2021/09/29.
//

import UIKit

protocol PhotoListCoordinatorDependencies {
    func makePhotoDetailViewController(photos: [Photo]) -> UIViewController
}

class PhotoListCoordinator {
    private weak var navigationConroller: UINavigationController?
    private let dependencies: PhotoListCoordinatorDependencies

    init(navigationConroller: UINavigationController, dependencies: PhotoListCoordinatorDependencies) {
        self.navigationConroller = navigationConroller
        self.dependencies = dependencies
    }

    // Private

    private func showPhotoDetail(photos: [Photo]) {
        let photoDetailViewController = dependencies.makePhotoDetailViewController(photos: photos)
        navigationConroller?.pushViewController(photoDetailViewController, animated: true)
    }
}
