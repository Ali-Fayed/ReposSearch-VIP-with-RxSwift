//
//  FetchReposUseCase.swift
//  RxSwift with DI and UnitTesting
//
//  Created by Ali Fayed on 27/12/2022.
//

import Foundation
import RxSwift
import RxCocoa
protocol FetchReposUseCase {
    typealias repositoriesObservable = (Observable<ApiResult<Repositories, ApiErrorMessage>>)
    func excute(page: Int, query: String) -> (repositoriesObservable)
}
