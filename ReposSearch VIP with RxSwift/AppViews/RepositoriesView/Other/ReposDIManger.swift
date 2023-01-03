//
//  DIManger.swift
//  ReposSearch VIP with RxSwift
//
//  Created by Ali Fayed on 27/12/2022.
//
import Swinject
class ReposDIManger {
    /// Dependency Injection Contatiner that contatin all Protocols and Thier Implemntation
    let container: Container = {
        let container = Container()
        container.register(FetchReposUseCase.self) { _ in
            return FetchRepos()
        }
        container.register(ReposDisplayLogic.self) { _ in
            return ReposViewDisplay()
        }
        container.register(ReposPresentationLogic.self) { resolver in
            return ReposViewPresenter(displayLogic: resolver.resolve(ReposDisplayLogic.self))
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
}
