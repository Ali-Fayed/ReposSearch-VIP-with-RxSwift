//
//  ReposPresenter.swift
//  RxSwift with DI and UnitTesting
//
//  Created by Ali Fayed on 27/12/2022.
//
final class ReposViewPresenter: ReposPresentationLogic {
    // MARK: - Properties
    var displayLogic: ReposDisplayLogic?
    // MARK: - Types
    typealias response = ReposVCModel.ReposAPIResponse
    typealias error = ReposVCModel.ReposAPIError
    // MARK: - Dependency Injection
    init(displayLogic: ReposDisplayLogic?) {
        self.displayLogic = displayLogic
    }
    // MARK: - Protocol Implementation
    /// cache response to viewModel and pass it to displayLogic that fill with the VC with data
    func presentReposViewWithResponse(response: response) {
        let viewModel = ReposVCModel.ReposViewModel(repos: response.repos)
        displayLogic?.displayVCwithData(viewModel: viewModel)
    }
    /// cache error  and pass it to displayLogic that fill with the VC with error
    func presentReposViewWithError(error: error) {
        let error = ReposVCModel.ReposAPIError(error: error.error)
        displayLogic?.displayVCwithError(error: error)
    }
}
