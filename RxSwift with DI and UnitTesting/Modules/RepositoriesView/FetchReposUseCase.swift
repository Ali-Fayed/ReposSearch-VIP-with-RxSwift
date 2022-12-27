//
//  FetchReposUseCase.swift
//  RxSwift with DI and UnitTesting
//
//  Created by Ali Fayed on 27/12/2022.
//
import Foundation
protocol FetchReposUseCase {
    func excute() async throws -> (Repositories)
}
final class FetchRepos: FetchReposUseCase {
    func excute() async throws -> (Repositories) {
        let requestValues = NetworkRequestValues(dataModel: Repositories.self, requestData: RequestRouter.searchRepos(page: 1, query: "swift"))
        let responese = try await NetworkManger.shared.performRequestt(requestValues: requestValues)
        return responese
    }
}
