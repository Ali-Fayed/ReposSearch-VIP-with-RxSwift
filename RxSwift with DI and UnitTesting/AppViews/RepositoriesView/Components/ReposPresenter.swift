//
//  ReposPresenter.swift
//  RxSwift with DI and UnitTesting
//
//  Created by Ali Fayed on 27/12/2022.
//
final class ReposViewPresenter: ReposPresentationLogic {
    var displayLogic: ReposDisplayLogic?
    typealias repoResponse = ReposModel.LoadRepos.ReposResponse
    typealias repoError = ReposModel.LoadRepos.ReposAPIError
    init(displayLogic: ReposDisplayLogic?) {
        self.displayLogic = displayLogic
    }
    func presentViewData(response: repoResponse) {
        let viewModel = ReposModel.LoadRepos.ReposViewModel(repos: response.repos)
        displayLogic?.displayData(viewModel: viewModel)
    }
    func presentRepoError(response: repoError) {
        let error = ReposModel.LoadRepos.ReposAPIError(error: response.error)
        displayLogic?.displayError(error: error)
    }
}
