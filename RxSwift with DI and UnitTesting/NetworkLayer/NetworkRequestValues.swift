//
//  NetworkRequestValues.swift
//  RxSwift with DI and UnitTesting
//
//  Created by Ali Fixed on 27/12/2022.
//

import Alamofire
struct NetworkRequestValues<T: Decodable>{
    let dataModel: T.Type
    let requestData: URLRequestConvertible
}
