//
//  TabBarController.swift
//  RxSwift with DI and UnitTesting
//
//  Created by Ali Fayed on 27/12/2022.
//

import UIKit
import Swinject
class TabBarViewController: UITabBarController {
    let container: Container = {
        let container = Container()
        container.register(FetchReposUseCase.self) { _ in
            return FetchRepos()
        }
        container.register(ReposPresentationLogic.self) { _ in
            return ReposViewPresenter()
        }
        container.register(ReposDisplayLogic.self) { _ in
            return ReposDisplay()
        }
        container.register(HomeInteractor.self) { resolver in
            let interactor = HomeInteractor(reposUseCase: resolver.resolve(FetchReposUseCase.self), presenter: resolver.resolve(ReposPresentationLogic.self))
            return interactor
        }
        container.register(ReposViewPresenter.self) { resolver in
            let presenter = ReposViewPresenter(displayLogic: resolver.resolve(ReposDisplayLogic.self))
            return presenter
        }
        return container
    }()
    func configureView(interactor: HomeInteractor, presenter: ReposViewPresenter) -> UIViewController {
     let view = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "RepositoriesViewController") as! RepositoriesViewController
      view.interactor = interactor
      interactor.presenter = presenter
      presenter.displayLogic = view
      return view
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let interactor = container.resolve(HomeInteractor.self) else {return}
        guard let presenter = container.resolve(ReposViewPresenter.self) else {return}
        let nav1 = UINavigationController(rootViewController: configureView(interactor: interactor, presenter: presenter))
        nav1.title = "Repos"
        nav1.navigationItem.largeTitleDisplayMode = .always
        nav1.navigationBar.prefersLargeTitles = true
        nav1.tabBarItem = UITabBarItem(title: "Repos", image: UIImage(systemName: "person"), tag: 1)
        setViewControllers([nav1], animated: false)
    }
}
