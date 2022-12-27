//
//  ReposInteractor.swift
//  RxSwift with DI and UnitTesting
//
//  Created by Ali Fayed on 27/12/2022.
//
final class HomeInteractor: ReposBusinessLogic {
    private let reposUseCase: FetchReposUseCase?
    var presenter: ReposPresentationLogic?
    init(reposUseCase: FetchReposUseCase?, presenter: ReposPresentationLogic?) {
        self.reposUseCase = reposUseCase
        self.presenter = presenter
    }
    func fetchRepositories(request: ReposModel.LoadRepos.Request) {
        Task {
            do {
                guard let repos = try await reposUseCase?.excute() else {return}
                let response = ReposModel.LoadRepos.ReposResponse(repos: repos.items)
                self.presenter?.presentViewData(response: response)
            } catch let error {
                let error = ReposModel.LoadRepos.ReposAPIError(error: error)
                self.presenter?.presentHomeError(response: error)
            }
        }
    }
}
