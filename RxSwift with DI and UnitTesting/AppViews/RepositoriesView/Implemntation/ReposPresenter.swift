//
//  ReposPresenter.swift
//  RxSwift with DI and UnitTesting
//
//  Created by Ali Fayed on 27/12/2022.
//
final class ReposViewPresenter: ReposPresentationLogic {
    var displayLogic: ReposDisplayLogic?
    typealias response = ReposVCModel.ReposAPIResponse
    typealias error = ReposVCModel.ReposAPIError
    init(displayLogic: ReposDisplayLogic?) {
        self.displayLogic = displayLogic
    }
    func presentReposViewWithResponse(response: response) {
        let viewModel = ReposVCModel.ReposViewModel(repos: response.repos)
        displayLogic?.displayVCwithData(viewModel: viewModel)
    }
    func presentReposViewWithError(error: error) {
        let error = ReposVCModel.ReposAPIError(error: error.error)
        displayLogic?.displayVCwithError(error: error)
    }
}
