//
//  TabBarController.swift
//  RxSwift with DI and UnitTesting
//
//  Created by Ali Fayed on 27/12/2022.
//
import UIKit
import Swinject
class TabBarViewController: UITabBarController {
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        initReposView()
    }
    // MARK: - View Logic
    func reposViewConfigurations(interactor: HomeInteractor, presenter: ReposViewPresenter) -> UIViewController {
        let view = ReposViewController.instaintiate(on: .main)
        view.interactor = interactor
        interactor.presenter = presenter
        presenter.displayLogic = view
        return view
    }
    func initReposView() {
        guard let interactor = ReposDIManger().container.resolve(HomeInteractor.self) else {return}
        guard let presenter = ReposDIManger().container.resolve(ReposViewPresenter.self) else {return}
        let nav = UINavigationController(rootViewController: reposViewConfigurations(interactor: interactor, presenter: presenter))
        nav.title = ReposVCConstants.viewTitle
        nav.navigationItem.largeTitleDisplayMode = .always
        nav.navigationBar.prefersLargeTitles = true
        nav.tabBarItem = UITabBarItem(title: ReposVCConstants.viewTitle, image: UIImage(systemName: ReposVCConstants.tabBarImage), tag: 1)
        setViewControllers([nav], animated: false)
    }
}
