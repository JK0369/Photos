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
    private var appTabBarController: UITabBarController?

    init(appDIContainer: AppDIContainer, photoListDIContainer: PhotoListDIContainer) {
        self.appDIContainer = appDIContainer
        self.photoListDIContainer = photoListDIContainer
    }

    func start(with window: UIWindow) {
        let viewControllers = [photoListDIContainer.makePhotoListViewController(actions: PhotoListViewModelActions(showPhotoDetail: showPhotoDetail))]
        let tabBarController = appDIContainer.makeTabBarController(viewControllers: viewControllers)
        appTabBarController = tabBarController

        window.rootViewController = tabBarController
    }

    private func showPhotoDetail(photos: [Photo], selectedIndexPath: IndexPath) {
        let viewController = photoListDIContainer.makePhotoDetailViewController(photos: photos, selectedIndexPath: selectedIndexPath)
        (appTabBarController?.selectedViewController as? UINavigationController)?.pushViewController(viewController, animated: true)
    }
}
