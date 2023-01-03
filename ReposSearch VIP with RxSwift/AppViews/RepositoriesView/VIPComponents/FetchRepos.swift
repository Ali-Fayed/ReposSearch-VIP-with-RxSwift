//
//  FetchRepos.swift
//  ReposSearch VIP with RxSwift
//
//  Created by Ali Fayed on 27/12/2022.
//
import RxSwift
final class FetchRepos: FetchReposUseCase {
    // MARK: - Types
    typealias observable = (Observable<ApiResult<Repositories, ApiError>>)
    // MARK: - Protocol Implementation
    func excute(page: Int, query: String) -> observable {
        /// this api call request return observable with APIresult and APIerror to handle this two cases
        let router = RequestRouter.searchRepos(page: page, query: query)
        /// requestValues is a generic model take two values the model we use it and router from alamofire request router enum
        let requestValues = NetworkRequestValues(dataType: Repositories.self, requestRouter: router)
        /// generic network layer takes a request value only
        let reposObservable = NetworkManger.shared.performRequest(requestValues: requestValues)
        return reposObservable
    }
}
