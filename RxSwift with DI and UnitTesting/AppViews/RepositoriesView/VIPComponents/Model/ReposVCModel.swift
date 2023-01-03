//
//  ReposModel.swift
//  RxSwift with DI and UnitTesting
//
//  Created by Ali Fayed on 27/12/2022.
//
enum ReposVCModel {
    /// this request fire when we call any API request
    struct Request{}
    /// this model we use it for cache any response from API directly and recieve its data from interactor
    struct ReposAPIResponse {
      var repos: [Repository]
    }
    /// this model we use it for API error handle and recieve its data from interactor
    struct ReposAPIError {
       var error: ApiError
    }
    /// thus model we use it with the ViewControllers and this recieve its value from the presenter
    struct ReposViewModel {
        var repos: [Repository]
    }
}
