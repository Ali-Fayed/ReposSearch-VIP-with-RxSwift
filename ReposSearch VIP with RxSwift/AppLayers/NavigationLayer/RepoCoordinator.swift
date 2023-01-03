//
//  RepoCoordinator.swift
//  ReposSearch VIP with RxSwift
//
//  Created by Ali Fayed on 01/01/2023.
//
import XCoordinator
import UIKit
import Swinject
import SafariServices
enum RepoTabRouter: Route {
    case repoTab
    case safariView(url: String)
}
class RepoCoordinator: NavigationCoordinator<RepoTabRouter> {
    init() {
        super.init(initialRoute: .repoTab)
    }
    override func prepareTransition(for route: RepoTabRouter) -> NavigationTransition {
        switch route {
        case .repoTab:
            let view = ReposViewController.instaintiate(on: .main)
            if let interactor = ReposDIManger().container.resolve(HomeInteractor.self) ,
               let presenter = ReposDIManger().container.resolve(ReposViewPresenter.self) {
                view.interactor = interactor
                interactor.presenter = presenter
                presenter.displayLogic = view
            }
            view.navigationItem.title = ReposVCConstants.viewTitle
            view.dataSource.router = unownedRouter
            return .push(view)
        case .safariView(let url):
            var safarViewController: SFSafariViewController!
            if let url = URL(string: url) {
                  let config = SFSafariViewController.Configuration()
                  config.entersReaderIfAvailable = true
                  let vc = SFSafariViewController(url: url, configuration: config)
                  safarViewController = vc
               }
            return .present(safarViewController)
        }
    }
}
