//
//  ReposInteractor.swift
//  ReposSearch VIP with RxSwift
//
//  Created by Ali Fayed on 27/12/2022.
//
import RxSwift
import RxCocoa
final class HomeInteractor: ReposBusinessLogic {
    // MARK: - Properties
    private let disposeBag = DisposeBag()
    private let reposUseCase: FetchReposUseCase?
    var showLoading = BehaviorRelay<Bool>(value: false)
    var presenter: ReposPresentationLogic?
    // MARK: - Types
    typealias request = ReposVCModel.Request
    // MARK: - Dependency Injection
    init(reposUseCase: FetchReposUseCase?, presenter: ReposPresentationLogic?) {
        self.reposUseCase = reposUseCase
        self.presenter = presenter
    }
    // MARK: - Protocol Implementation
    func fetchRepositories(request: request, page: Int, query: String, isPaginating: Bool) {
        /// check for pagination state to not show center loading indicator
        if !isPaginating { showLoading.accept(true) }
        guard let repoObservable = reposUseCase?.excute(page: page, query: query) else {return}
        repoObservable.subscribe(onNext: { result in
            switch result {
            case let .success(repo):
                /// if response code is 200 ... 300
                self.showLoading.accept(false)
                /// cache response to model api response and pass them to presenter
                let response = ReposVCModel.ReposAPIResponse(repos: repo.items)
                self.presenter?.presentReposViewWithResponse(response: response)
            case let .failure(error):
                /// if response code is 400 ... 500  and pass them to presenter
                let error = ReposVCModel.ReposAPIError(error: error)
                /// cache error  and pass them to presenter
                self.presenter?.presentReposViewWithError(error: error)
            }
        }, onError:{ error in
            /// unexpecting errors like data type error or connection issues  and pass them to presenter
            let defaultErrorValue = ApiError(message: error.localizedDescription, documentation_url: "")
            let error = ReposVCModel.ReposAPIError(error: error as? ApiError ?? defaultErrorValue)
            /// cache error  and pass them to presenter
            self.presenter?.presentReposViewWithError(error: error)
        }).disposed(by: disposeBag)
    }
}
