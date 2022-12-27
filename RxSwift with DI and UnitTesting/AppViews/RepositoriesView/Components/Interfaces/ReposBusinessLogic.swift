//
//  ReposBusinessLogic.swift
//  RxSwift with DI and UnitTesting
//
//  Created by Ali Fayed on 27/12/2022.
//

import Foundation
protocol ReposBusinessLogic {
  func fetchRepositories(request: ReposModel.LoadRepos.Request)
}
