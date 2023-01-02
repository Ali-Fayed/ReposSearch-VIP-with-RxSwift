//
//  ReposBusinessLogic.swift
//  RxSwift with DI and UnitTesting
//
//  Created by Ali Fayed on 27/12/2022.
//
import RxCocoa
protocol ReposBusinessLogic {
    typealias request = ReposVCModel.Request
    var showLoading: BehaviorRelay<Bool> {get set}
    func fetchRepositories(request: request, page: Int, query: String)
}
