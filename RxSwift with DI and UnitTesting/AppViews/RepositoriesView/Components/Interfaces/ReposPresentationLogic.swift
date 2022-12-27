//
//  ReposPresentation.swift
//  RxSwift with DI and UnitTesting
//
//  Created by Ali Fayed on 27/12/2022.
//

import Foundation
protocol ReposPresentationLogic {
  func presentViewData(response: ReposModel.LoadRepos.ReposResponse)
  func presentHomeError(response: ReposModel.LoadRepos.ReposAPIError)
}
