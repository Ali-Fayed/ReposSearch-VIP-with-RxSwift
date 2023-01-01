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
    func excute() -> (Observable<ApiResult<Repositories, ApiErrorMessage>>) {
        let requestValues = NetworkRequestValues(dataModel: Repositories.self, requestData: RequestRouter.searchRepos(page: ReposViewConstants.page, query: ReposViewConstants.baseSearchKeywoard))
        let responese = NetworkManger.shared.performRequest(requestValues: requestValues)
        return responese
    }
}
