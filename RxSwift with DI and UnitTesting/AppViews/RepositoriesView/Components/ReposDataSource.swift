//
//  ReposDataSource.swift
//  RxSwift with DI and UnitTesting
//
//  Created by Ali Fayed on 27/12/2022.
//
import RxSwift
import RxCocoa
class ReposDataSource {
    let showLoading = BehaviorRelay<Bool>(value: true)
    let reposSubject = PublishSubject<[Repository]>()
    let errorSubject = PublishSubject<ApiErrorMessage>()
}
