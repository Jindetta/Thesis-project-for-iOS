//
//  SceneDelegate.swift
//  Thesis-project
//
//  Created by Joonas Lauhala on 21.2.2020.
//  Copyright © 2020 Joonas Lauhala. All rights reserved.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let rootViewController = mainStoryboard.instantiateViewController(withIdentifier: "MainViewController")
        let navigationController = UINavigationController(rootViewController: rootViewController)
        
        window = UIWindow(windowScene: scene as! UIWindowScene)
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }

}

