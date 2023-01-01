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
        viewDataSource.reposSubject.onNext(viewModel.repos)
        viewDataSource.reposSubject.onCompleted()
    }
    func displayError(error: repoError) {
        viewDataSource.errorSubject.onError(error.error)
        viewDataSource.errorSubject.onCompleted()
    }
}
