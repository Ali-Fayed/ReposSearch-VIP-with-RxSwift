//
//  ReposModel.swift
//  RxSwift with DI and UnitTesting
//
//  Created by Ali Fayed on 27/12/2022.
//
enum ReposVCModel {
    struct Request{}
    struct ReposAPIResponse {
      var repos: [Repository]
    }
    struct ReposAPIError {
        var error: ApiError
    }
    struct ReposViewModel {
        var repos: [Repository]
    }
}
