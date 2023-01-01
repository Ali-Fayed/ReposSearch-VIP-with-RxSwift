//
//  ReposPresentation.swift
//  RxSwift with DI and UnitTesting
//
//  Created by Ali Fayed on 27/12/2022.
//

import Foundation
protocol ReposPresentationLogic {
  typealias repoResponse = ReposModel.LoadRepos.ReposResponse
  typealias repoError = ReposModel.LoadRepos.ReposAPIError
  func presentViewData(response: repoResponse)
  func presentRepoError(response: repoError)
}
