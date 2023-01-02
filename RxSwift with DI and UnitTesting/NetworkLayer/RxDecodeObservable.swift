//
//  Observable.swift
//  RxSwift with DI and UnitTesting
//
//  Created by Ali Fayed on 01/01/2023.
//
import UIKit
import RxCocoa
import RxSwift
extension Observable where Element == (HTTPURLResponse, Data){
     func expectingType<T : Decodable>(of type: T.Type) -> Observable<ApiResult<T, ApiError>>{
        return self.map{ (httpURLResponse, data) -> ApiResult<T, ApiError> in
            switch Int(httpURLResponse.statusCode) {
            case 200 ... 299:
                // is status code is successful we can safely decode to our expected type T
                let object = try JSONDecoder().decode(type, from: data)
                return .success(object)
            default:
                // otherwise try
                let apiErrorMessage: ApiError
                do{
                    // to decode an expected error
                    apiErrorMessage = try JSONDecoder().decode(ApiError.self, from: data)
                } catch _ {
                    // or not. (this occurs if the API failed or doesn't return a handled exception)
                    apiErrorMessage = ApiError(message: "Server Error.", documentation_url: "")
                }
                return .failure(apiErrorMessage)
            }
        }
    }
}
enum ApiResult<Value, Error>{
    case success(Value)
    case failure(Error)
    
    init(value: Value){
        self = .success(value)
    }
    
    init(error: Error){
        self = .failure(error)
    }
}
