//
//  AppTapBarController.swift
//  Unsplash
//
//  Created by 김종권 on 2021/09/29.
//

import UIKit

class AppTapBarController: BaseTabBarController {

    static func create(with viewControllers: [UIViewController]) -> AppTapBarController {
        let appTapBarController = AppTapBarController()
        appTapBarController.setNavigationControllers(with: viewControllers)

        return appTapBarController
    }

    override func configure() {
        super.configure()

        setupTabBarColor()
    }

    private func setupTabBarColor() {
        tabBar.barTintColor = .black
    }

    private func setNavigationControllers(with viewControllers: [UIViewController]) {
        var navigationControllers = [UINavigationController]()
        viewControllers.forEach { viewController in
            let navigationController = UINavigationController(rootViewController: viewController)
            navigationControllers.append(navigationController)
        }
        setViewControllers(navigationControllers, animated: false)
    }
}
