//
//  ReposDataSource.swift
//  RxSwift with DI and UnitTesting
//
//  Created by Ali Fayed on 27/12/2022.
//

import Foundation
import RxSwift
import RxCocoa
class ReposDataSource {
    let reposSubject = PublishSubject<[Repository]>()
    let errorSubject = PublishSubject<Error>()
    var loadingState = BehaviorRelay<Bool>(value: false)
    var errorState = BehaviorRelay<(Bool, String)>(value: (false, ""))
}
