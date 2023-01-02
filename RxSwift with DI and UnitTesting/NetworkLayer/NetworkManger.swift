//
//  NetworkManger.swift
//  RxSwift with DI and UnitTesting
//
//  Created by Ali Fayed on 27/12/2022.
//
import RxSwift
import RxCocoa
import RxAlamofire
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
    func performRequest<T: Decodable>(requestValues: NetworkRequestValues<T>) -> (Observable<ApiResult<T, ApiError>>) {
        return self.afSession.rx.request(urlRequest: requestValues.requestRouter)
            .observe(on: MainScheduler.instance)
            .responseData()
            .expectingType(of: T.self)
            .map { (response) in
                return response
            }.asObservable()
    }
}
