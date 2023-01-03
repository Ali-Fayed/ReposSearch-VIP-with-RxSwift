//
//  ReposViewDisplay.swift
//  ReposSearch VIP with RxSwift
//
//  Created by Ali Fayed on 27/12/2022.
//
import UIKit
class ReposViewDisplay: UIViewController, ReposDisplayLogic {
    // MARK: - Properties
    var dataSource = ReposDataSource()
    // MARK: - Types
    typealias viewModel = ReposVCModel.ReposViewModel
    typealias error = ReposVCModel.ReposAPIError
    // MARK: - Protocol Implementation
    func displayVCwithData(viewModel: viewModel) {
        /// check for searching state to append or replace value when search or not
        if dataSource.isSearching.value {
            /// replace the current subject values with new that come from search
            dataSource.reposData = viewModel.repos
        } else {
            /// append to the current subject values with new data
            dataSource.reposData.append(contentsOf: viewModel.repos)
        }
        /// sectioned tableView data source if we need to add a section name or more sections
        let section = ReposSectionModel(header: ReposVCConstants.firstSectionName, items: dataSource.reposData)
        dataSource.reposSubject.onNext([section])
    }
    func displayVCwithError(error: error) {
        /// send error model to the UI
        dataSource.errorBehaviour.accept(error.error)
    }
}
