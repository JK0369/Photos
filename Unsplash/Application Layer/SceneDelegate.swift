//
//  SceneDelegate.swift
//  Unsplash
//
//  Created by 김종권 on 2021/09/29.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    let appDIContainer = AppDIContainer()
    var appCoordinator: AppCoordinator?
    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {

        AppAppearance.setupAppearance()
        
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: windowScene)
        self.window = window

        appCoordinator = AppCoordinator(appDIContainer: appDIContainer,
                                        photoListDIContainer: appDIContainer.makePhotoListDIContainer(),
                                        photoSearchDIContainer: appDIContainer.makePhotoSearchDIContainer())
        appCoordinator?.start(with: window)
        window.makeKeyAndVisible()
    }

    func sceneDidDisconnect(_ scene: UIScene) {}
    func sceneDidBecomeActive(_ scene: UIScene) {}
    func sceneWillResignActive(_ scene: UIScene) {}
    func sceneWillEnterForeground(_ scene: UIScene) {}
    func sceneDidEnterBackground(_ scene: UIScene) {}
}

