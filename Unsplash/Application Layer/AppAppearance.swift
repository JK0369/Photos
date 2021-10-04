//
//  AppAppearance.swift
//  Unsplash
//
//  Created by 김종권 on 2021/10/03.
//

import Foundation
import UIKit

final class AppAppearance {

    static func setupAppearance() {

        // NavigationBar
        UINavigationBar.appearance().barTintColor = .black
        UINavigationBar.appearance().tintColor = .white
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]

        // TabBar
        UITabBar.appearance().tintColor = .white
    }
}
