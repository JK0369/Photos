//
//  AppDIContainer.swift
//  Unsplash
//
//  Created by 김종권 on 2021/09/29.
//

import Foundation
import UIKit

final class AppDIContainer {

    lazy var appConfiguration = AppConfiguration()

    // MARK: - Network

    lazy var provider: Provider = {
        return ProviderImpl()
    }()

    // MARK: - DIContainers of scenes

    func makeTabBarController(viewControllers: [UIViewController]) -> AppTapBarController {
        let appTapBarController = AppTapBarController.create(with: viewControllers)

        return appTapBarController
    }

    func makePhotoListDIContainer() -> PhotoListDIContainer {
        let dependencies = PhotoListDIContainer.Dependencies(provider: provider)

        return PhotoListDIContainer(dependencies: dependencies)
    }
}
