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
    func excute() -> (Observable<ApiResult<Repositories, ApiErrorMessage>>)
}
