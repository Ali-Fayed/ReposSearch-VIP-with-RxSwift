//
//  FetchReposUseCase.swift
//  RxSwift with DI and UnitTesting
//
//  Created by Ali Fayed on 27/12/2022.
//
import RxSwift
protocol FetchReposUseCase {
    typealias reposObservable = (Observable<ApiResult<Repositories, ApiError>>)
    func excute(page: Int, query: String) -> reposObservable
}
