//
//  ReposDisplayLogic.swift
//  RxSwift with DI and UnitTesting
//
//  Created by Ali Fayed on 27/12/2022.
//

import Foundation
protocol ReposDisplayLogic {
  func displayData(viewModel: ReposModel.LoadRepos.ReposViewModel)
  func displayError(error: ReposModel.LoadRepos.ReposAPIError)
}
