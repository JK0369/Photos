//
//  AppCoordinator.swift
//  Unsplash
//
//  Created by 김종권 on 2021/09/29.
//

import Foundation
import UIKit

class AppCoordinator {
    private let appDIContainer: AppDIContainer
    private let photoListDIContainer: PhotoListDIContainer
    private let photoSearchDIContainer: PhotoSearchDIContainer

    init(appDIContainer: AppDIContainer, photoListDIContainer: PhotoListDIContainer, photoSearchDIContainer: PhotoSearchDIContainer) {
        self.appDIContainer = appDIContainer
        self.photoListDIContainer = photoListDIContainer
        self.photoSearchDIContainer = photoSearchDIContainer
    }

    func start(with window: UIWindow) {

        // PhotoList

        let photoListNavigationController = UINavigationController()
        let photoListCoordinator = photoListDIContainer.makePhotoListCoordinator(navigationController: photoListNavigationController)
        let photoListViewModelActions = PhotoListViewModelActions(showPhotoDetail: photoListCoordinator.showPhotoDetail(photos:selectedIndexPath:))
        let photoListViewController = photoListDIContainer.makePhotoListViewController(actions: photoListViewModelActions)
        photoListNavigationController.setViewControllers([photoListViewController], animated: false)

        // PhotoSearch

        let photoSearchNavigationController = UINavigationController()
        let photoSearchCoordinator = photoSearchDIContainer.makePhotoSearchCoordinator(navigationController: photoSearchNavigationController)
        let photoSearchViewModelActions = PhotoSearchViewModelActions(showPhotoDetail: photoSearchCoordinator.showPhotoDetail(photos:selectedIndexPath:))
        let photoSearchViewController = photoSearchDIContainer.makePhotoSearchViewController(actions: photoSearchViewModelActions)
        photoSearchNavigationController.setViewControllers([photoSearchViewController], animated: false)

        // AppTabBar

        let tabBarController = appDIContainer.makeTabBarController(viewControllers: [photoListNavigationController,
                                                                                     photoSearchNavigationController])
        window.rootViewController = tabBarController
    }
}
