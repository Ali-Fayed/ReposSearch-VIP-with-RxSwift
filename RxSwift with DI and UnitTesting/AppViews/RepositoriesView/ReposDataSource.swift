//
//  ReposDataSource.swift
//  RxSwift with DI and UnitTesting
//
//  Created by Ali Fayed on 27/12/2022.
//
import RxSwift
import RxCocoa
class ReposDataSource {
    // MARK: - Rx Properties
    let reposSubject = PublishSubject<[Repository]>()
    var isSearching = BehaviorRelay<Bool>(value: false)
    let showLoading = BehaviorRelay<Bool>(value: true)
    let errorBehaviour = BehaviorRelay<ApiError>(value: ApiError(message: "", documentation_url: ""))
    // MARK: - Normal Properties
    var reposData = [Repository]()
    var searchText = "swift"
    var pageNo = 1
    var totalPages = 100
}
