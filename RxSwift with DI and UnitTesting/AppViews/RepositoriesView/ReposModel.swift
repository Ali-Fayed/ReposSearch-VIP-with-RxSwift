//
//  ReposModel.swift
//  RxSwift with DI and UnitTesting
//
//  Created by Ali Fayed on 27/12/2022.
//
enum ReposModel {
  enum LoadRepos {
    struct Request{}
    struct ReposResponse {
      var repos: [Repository]
    }
    struct ReposAPIError {
        var error: Error
    }
    struct ReposViewModel {
        var repos: [Repository]
    }
  }
}
