//
//  DisplayLogic.swift
//  RxSwift with DI and UnitTesting
//
//  Created by Ali Fayed on 27/12/2022.
//
import UIKit
class ReposViewDisplay: UIViewController, ReposDisplayLogic {
    typealias repoViewModel = ReposModel.LoadRepos.ReposViewModel
    typealias repoError = ReposModel.LoadRepos.ReposAPIError
    var viewDataSource = ReposDataSource()
    func displayData(viewModel: repoViewModel) {
        viewDataSource.reposData.append(contentsOf: viewModel.repos)
        viewDataSource.searchReposData = viewModel.repos
        if viewDataSource.isSearching.value {
            viewDataSource.reposSubject.onNext(viewDataSource.searchReposData)
        } else {
            viewDataSource.reposSubject.onNext(viewDataSource.reposData)
        }
    }
    func displayError(error: repoError) {
        viewDataSource.errorSubject.onError(error.error)
        viewDataSource.errorSubject.onCompleted()
    }
}
