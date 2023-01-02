//
//  AppCoordinator.swift
//  RxSwift with DI and UnitTesting
//
//  Created by Ali Fayed on 01/01/2023.
//
import UIKit
import Foundation
import XCoordinator
enum AppRoute: Route {
    case tabBarViews
}
class AppCoordinator: NavigationCoordinator<AppRoute> {
    init() {
        super.init(initialRoute: .tabBarViews)
    }
    override func prepareTransition(for route: AppRoute) -> NavigationTransition {
        switch route {
        case .tabBarViews:
            let tabCoordinator = HomeTabBarCoordinator()
            tabCoordinator.rootViewController.modalPresentationStyle = .overFullScreen
            return .present(tabCoordinator)
        }
    }
}
