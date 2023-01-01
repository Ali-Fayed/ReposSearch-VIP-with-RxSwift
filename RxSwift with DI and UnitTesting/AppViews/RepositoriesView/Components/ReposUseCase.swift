//
//  FetchReposUseCase.swift
//  RxSwift with DI and UnitTesting
//
//  Created by Ali Fayed on 27/12/2022.
//
import Foundation
import RxSwift
import RxCocoa
final class FetchRepos: FetchReposUseCase {
    typealias repositoriesObservable = (Observable<ApiResult<Repositories, ApiErrorMessage>>)
    func excute() -> repositoriesObservable {
        let requestValues = NetworkRequestValues(dataType: Repositories.self, requestRouter: RequestRouter.searchRepos(page: ReposViewConstants.page, query: ReposViewConstants.baseSearchKeywoard))
        let reposObservable = NetworkManger.shared.performRequest(requestValues: requestValues)
        return reposObservable
    }
}
