//
//  AppTabBarController.swift
//  Unsplash
//
//  Created by 김종권 on 2021/09/29.
//

import UIKit

class AppTabBarController: BaseTabBarController {

    static func create(with viewControllers: [UIViewController]) -> AppTabBarController {
        let appTabBarController = AppTabBarController()
        appTabBarController.setViewControllers(viewControllers, animated: false)

        return appTabBarController
    }

    override func configure() {
        super.configure()

        setupTabBarColor()
    }

    private func setupTabBarColor() {
        tabBar.barTintColor = .black
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        setupTabBarItems()
    }

    private func setupTabBarItems() {
        viewControllers?.forEach{ viewController in
            let viewController = (viewController as? UINavigationController)?.viewControllers.first

            if viewController is PhotoListViewController {
                viewController?.tabBarItem = UITabBarItem(title: nil, image: UIImage(systemName: "photo"), tag: 0)
                
            } else if viewController is PhotoSearchViewController {
                viewController?.tabBarItem = UITabBarItem(title: nil, image: UIImage(systemName: "magnifyingglass"), tag: 1)
            }
        }
    }
}
