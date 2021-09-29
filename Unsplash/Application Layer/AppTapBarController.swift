//
//  AppTapBarController.swift
//  Unsplash
//
//  Created by 김종권 on 2021/09/29.
//

import UIKit

class AppTapBarController: BaseTabBarController {

    init(viewControllers: [UIViewController]) {
        super.init(nibName: nil, bundle: nil)

        setNavigationControllers(with: viewControllers)
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
