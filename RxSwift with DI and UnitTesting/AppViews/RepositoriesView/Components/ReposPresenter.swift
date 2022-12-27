//
//  ReposPresenter.swift
//  RxSwift with DI and UnitTesting
//
//  Created by Ali Fayed on 27/12/2022.
//
final class ReposViewPresenter: ReposPresentationLogic {
    var displayLogic: ReposDisplayLogic?
    init(displayLogic: ReposDisplayLogic? = nil) {
        self.displayLogic = displayLogic
    }
    func presentViewData(response: ReposModel.LoadRepos.ReposResponse) {
        let viewModel = ReposModel.LoadRepos.ReposViewModel(repos: response.repos)
        displayLogic?.displayData(viewModel: viewModel)
    }
    func presentHomeError(response: ReposModel.LoadRepos.ReposAPIError) {
        let error = ReposModel.LoadRepos.ReposAPIError(error: response.error)
        displayLogic?.displayError(error: error)
    }
}
