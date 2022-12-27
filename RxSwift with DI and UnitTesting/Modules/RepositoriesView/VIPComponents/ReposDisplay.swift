//
//  DisplayLogic.swift
//  RxSwift with DI and UnitTesting
//
//  Created by Ali Fayed on 27/12/2022.
//

import UIKit
protocol ReposDisplayLogic {
  func displayData(viewModel: ReposModel.LoadRepos.ReposViewModel)
  func displayError(error: ReposModel.LoadRepos.ReposAPIError)
}
class ReposDisplay: UIViewController, ReposDisplayLogic {
    var dataSource = ReposDataSource()
    func displayData(viewModel: ReposModel.LoadRepos.ReposViewModel) {
        dataSource.reposSubject.onNext(viewModel.repos)
        dataSource.reposSubject.onCompleted()
    }
    func displayError(error: ReposModel.LoadRepos.ReposAPIError) {
        dataSource.errorSubject.onNext(error.error)
        dataSource.errorSubject.onCompleted()
    }
}
