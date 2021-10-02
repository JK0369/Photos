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

    init(appDIContainer: AppDIContainer, photoListDIContainer: PhotoListDIContainer) {
        self.appDIContainer = appDIContainer
        self.photoListDIContainer = photoListDIContainer
    }

    func start(with window: UIWindow) {
        let actions = PhotoListViewModelAction(showPhotoDetail: showPhotoDetail(photo:))
        let viewControllers = [photoListDIContainer.makePhotoListViewController()]
        let tabBarController = appDIContainer.makeTabBarController(viewControllers: viewControllers)
        window.rootViewController = tabBarController
    }

    private func showPhotoDetail(photo: Photo) {
        // TODO:
//        let viewController = dependencies.
    }
}
