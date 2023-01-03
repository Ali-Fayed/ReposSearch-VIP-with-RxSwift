//
//  APIResult.swift
//  ReposSearch VIP with RxSwift
//
//  Created by Ali Fayed on 03/01/2023.
//
import Foundation
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
