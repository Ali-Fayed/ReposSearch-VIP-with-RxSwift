//
//  ReposPresentation.swift
//  ReposSearch VIP with RxSwift
//
//  Created by Ali Fayed on 27/12/2022.
//
protocol ReposPresentationLogic {
  typealias response = ReposVCModel.ReposAPIResponse
  typealias error = ReposVCModel.ReposAPIError
  func presentReposViewWithResponse(response: response)
  func presentReposViewWithError(error: error)
}
