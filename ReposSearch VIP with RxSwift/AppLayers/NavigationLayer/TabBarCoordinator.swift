//
//  TabBarCoordinator.swift
//  ReposSearch VIP with RxSwift
//
//  Created by Ali Fayed on 01/01/2023.
//
import UIKit
import XCoordinator
enum TabBarRoute: Route {
    case repoTab
}
class HomeTabBarCoordinator: TabBarCoordinator<TabBarRoute> {
    private let repoTabRouter: StrongRouter<RepoTabRouter>
    // MARK: - Initialization
    convenience init() {
        let repoCoordinator = RepoCoordinator()
        repoCoordinator.rootViewController.navigationBar.prefersLargeTitles = true
        repoCoordinator.rootViewController.navigationItem.largeTitleDisplayMode = .always
        repoCoordinator.rootViewController.tabBarItem =
        UITabBarItem(title: ReposVCConstants.viewTitle, image: UIImage(systemName: ReposVCConstants.tabBarImage), selectedImage: UIImage(systemName: ReposVCConstants.tabBarImage))
        self.init(repoTabRouter: repoCoordinator.strongRouter)
    }
    init(repoTabRouter: StrongRouter<RepoTabRouter>) {
        self.repoTabRouter = repoTabRouter
        super.init(tabs: [repoTabRouter], select: repoTabRouter)
    }
    // MARK: - Overrides
    override func prepareTransition(for route: TabBarRoute) -> TabBarTransition {
        switch route {
        case .repoTab:
            return .select(repoTabRouter)
        }
    }
 }
