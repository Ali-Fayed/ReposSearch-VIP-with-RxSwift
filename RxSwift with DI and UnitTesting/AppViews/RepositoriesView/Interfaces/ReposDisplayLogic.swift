//
//  ReposDisplayLogic.swift
//  RxSwift with DI and UnitTesting
//
//  Created by Ali Fayed on 27/12/2022.
//

import Foundation
protocol ReposDisplayLogic {
  typealias repoViewModel = ReposModel.LoadRepos.ReposViewModel
  typealias repoError = ReposModel.LoadRepos.ReposAPIError
  func displayData(viewModel: repoViewModel)
  func displayError(error: repoError)
}
