//
//  ReposDataSource.swift
//  RxSwift with DI and UnitTesting
//
//  Created by Ali Fayed on 27/12/2022.
//
import RxSwift
import RxCocoa
class ReposDataSource {
    var reposData = [Repository]()
    var isSearching = BehaviorRelay<Bool>(value: false)
    let showLoading = BehaviorRelay<Bool>(value: true)
    let reposSubject = PublishSubject<[Repository]>()
    let errorSubject = PublishSubject<ApiError>()
    var pageNo = 1
    var totalPages = 100
    var baseSearchKeywoard = "swift"
}
