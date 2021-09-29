//
//  BaseTabBarController.swift
//  Unsplash
//
//  Created by 김종권 on 2021/09/29.
//

import UIKit

class BaseTabBarController: UITabBarController {

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nil, bundle: nil)

        configure()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure() {}
}
