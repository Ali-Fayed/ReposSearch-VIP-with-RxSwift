//
//  SceneDelegate.swift
//  ReposSearch VIP with RxSwift
//
//  Created by Ali Fayed on 27/12/2022.
//
import UIKit
import XCoordinator
class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    let router = AppCoordinator().strongRouter
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let _ = (scene as? UIWindowScene) else { return }
        initAppRouting()
    }
    func initAppRouting () {
        router.setRoot(for: window!)
        window?.overrideUserInterfaceStyle = .dark
    }
    func sceneDidDisconnect(_ scene: UIScene) {
    }
    func sceneDidBecomeActive(_ scene: UIScene) {
    }
    func sceneWillResignActive(_ scene: UIScene) {
    }
    func sceneWillEnterForeground(_ scene: UIScene) {
    }
    func sceneDidEnterBackground(_ scene: UIScene) {
        (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
    }
}
