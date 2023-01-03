//
//  NetworkRequestValues.swift
//  ReposSearch VIP with RxSwift
//
//  Created by Ali Fayed on 27/12/2022.
//
import Alamofire
struct NetworkRequestValues<T: Decodable>{
    let dataType: T.Type
    let requestRouter: URLRequestConvertible
}
