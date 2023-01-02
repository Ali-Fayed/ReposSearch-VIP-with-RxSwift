//
//  DisplayLogic.swift
//  RxSwift with DI and UnitTesting
//
//  Created by Ali Fayed on 27/12/2022.
//
import UIKit
class ReposViewDisplay: UIViewController, ReposDisplayLogic {
    typealias viewModel = ReposVCModel.ReposViewModel
    typealias error = ReposVCModel.ReposAPIError
    var dataSource = ReposDataSource()
    func displayVCwithData(viewModel: viewModel) {
        if dataSource.isSearching.value {
            dataSource.reposData = viewModel.repos
            dataSource.reposSubject.onNext(dataSource.reposData)
        } else {
            dataSource.reposData.append(contentsOf: viewModel.repos)
            dataSource.reposSubject.onNext(dataSource.reposData)
        }
    }
    func displayVCwithError(error: error) {
        dataSource.errorBehaviour.accept(error.error)
    }
}
