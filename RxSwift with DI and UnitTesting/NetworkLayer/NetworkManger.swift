//
//  NetworkManger.swift
//  RxSwift with DI and UnitTesting
//
//  Created by Ali Fayed on 27/12/2022.
//

import Alamofire
struct NetworkManger {
    static let shared = NetworkManger()
    let afSession: Session = {
        let networkLogger = NetworkLogger()
        let interceptor = RequestIntercptor()
        return Session(
            interceptor: interceptor,
            eventMonitors: [networkLogger])
    }()
    func performRequestt<T: Decodable>(requestValues: NetworkRequestValues<T>) async throws -> (T) {
        let dataTask = afSession.request(requestValues.requestData).serializingDecodable(T.self)
        let response = await dataTask.response
        let result = response.result
        let model: T = try await withCheckedThrowingContinuation({ continuation in
            switch result {
            case .success(let users):
                continuation.resume(returning: users)
            case .failure(let error):
                continuation.resume(throwing: error)
            }
        })
        return model
    }
}
