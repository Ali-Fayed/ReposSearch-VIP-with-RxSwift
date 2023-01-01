//
//  DisplayLogic.swift
//  RxSwift with DI and UnitTesting
//
//  Created by Ali Fayed on 27/12/2022.
//
import UIKit
class ReposViewDisplay: UIViewController, ReposDisplayLogic {
    var viewDataSource = ReposDataSource()
    func displayData(viewModel: ReposModel.LoadRepos.ReposViewModel) {
        viewDataSource.reposSubject.onNext(viewModel.repos)
        viewDataSource.reposSubject.onCompleted()
    }
    func displayError(error: ReposModel.LoadRepos.ReposAPIError) {
        viewDataSource.reposSubject.onError(error.error)
        viewDataSource.reposSubject.onCompleted()
    }
}
