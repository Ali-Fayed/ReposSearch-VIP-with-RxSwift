//
//  FetchReposUseCase.swift
//  ReposSearch VIP with RxSwift
//
//  Created by Ali Fayed on 27/12/2022.
//
import RxSwift
protocol FetchReposUseCase {
    typealias observable = (Observable<ApiResult<Repositories, ApiError>>)
    func excute(page: Int, query: String) -> observable
}
