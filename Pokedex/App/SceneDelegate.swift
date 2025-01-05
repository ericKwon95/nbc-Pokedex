//
//  SceneDelegate.swift
//  Pokedex
//
//  Created by 권승용 on 12/27/24.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: windowScene)
        let rootVC = UINavigationController(rootViewController: MainViewController())
        window.rootViewController = rootVC
        window.makeKeyAndVisible()
        self.window = window
    }
}

