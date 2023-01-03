//
//  ReposDisplayLogic.swift
//  ReposSearch VIP with RxSwift
//
//  Created by Ali Fayed on 27/12/2022.
//
protocol ReposDisplayLogic {
  typealias viewModel = ReposVCModel.ReposViewModel
  typealias error = ReposVCModel.ReposAPIError
  func displayVCwithData(viewModel: viewModel)
  func displayVCwithError(error: error)
}
