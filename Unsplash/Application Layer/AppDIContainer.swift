//
//  AppDIContainer.swift
//  Unsplash
//
//  Created by 김종권 on 2021/09/29.
//

import Foundation
import UIKit

final class AppDIContainer {

    // Network

    lazy var provider: Provider = {
        return ProviderImpl()
    }()

    // Util

    lazy var imageCache: ImageCachable = {
        return ImageCacheImpl(provider: provider)
    }()

    // DIContainers of scenes

    func makePhotoListDIContainer() -> PhotoListDIContainer {
        let dependencies = PhotoListDIContainer.Dependencies(provider: provider, imageCache: imageCache)

        return PhotoListDIContainer(dependencies: dependencies)
    }

    func makePhotoSearchDIContainer() -> PhotoSearchDIContainer {
        let dependencies = PhotoSearchDIContainer.Dependencies(provider: provider, imageCache: imageCache)

        return PhotoSearchDIContainer(dependencies: dependencies)
    }

    func makeAppTabBarController(viewControllers: [UIViewController]) -> AppTabBarController {
        let appTabBarController = AppTabBarController.create(with: viewControllers)

        return appTabBarController
    }
}
