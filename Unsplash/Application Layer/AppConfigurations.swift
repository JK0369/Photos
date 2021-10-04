//
//  AppConfigurations.swift
//  Unsplash
//
//  Created by 김종권 on 2021/09/29.
//

import Foundation

final class AppConfiguration {
    static let accessKey: String = {
        guard let accessKey = Bundle.main.object(forInfoDictionaryKey: "UnsplashAccessKey") as? String else {
            fatalError("UnsplashAccessKey must not be empty in plist")
        }
        return accessKey
    }()
}
