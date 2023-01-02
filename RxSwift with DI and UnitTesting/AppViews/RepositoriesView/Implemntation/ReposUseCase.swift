//
//  FetchReposUseCase.swift
//  RxSwift with DI and UnitTesting
//
//  Created by Ali Fayed on 27/12/2022.
//
import RxSwift
final class FetchRepos: FetchReposUseCase {
    typealias reposObservable = (Observable<ApiResult<Repositories, ApiError>>)
    func excute(page: Int, query: String) -> reposObservable {
        let router = RequestRouter.searchRepos(page: page, query: query)
        let requestValues = NetworkRequestValues(dataType: Repositories.self, requestRouter: router)
        let reposObservable = NetworkManger.shared.performRequest(requestValues: requestValues)
        return reposObservable
    }
}
