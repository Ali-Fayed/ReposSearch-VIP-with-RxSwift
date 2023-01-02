//
//  ReposInteractor.swift
//  RxSwift with DI and UnitTesting
//
//  Created by Ali Fayed on 27/12/2022.
//
import RxSwift
import RxCocoa
final class HomeInteractor: ReposBusinessLogic {
    private let disposeBag = DisposeBag()
    private let reposUseCase: FetchReposUseCase?
    typealias request = ReposVCModel.Request
    var showLoading = BehaviorRelay<Bool>(value: false)
    var presenter: ReposPresentationLogic?
    init(reposUseCase: FetchReposUseCase?, presenter: ReposPresentationLogic?) {
        self.reposUseCase = reposUseCase
        self.presenter = presenter
    }
    func fetchRepositories(request: request, page: Int, query: String, isPaginating: Bool) {
        // check for pagination state to not show center loading indicator
        if !isPaginating { showLoading.accept(true) }
        guard let repoObservable = reposUseCase?.excute(page: page, query: query) else {return}
        repoObservable.subscribe(onNext: { result in
            switch result {
            case let .success(repo):
                // if response code is 200 ... 300
                self.showLoading.accept(false)
                // cache response to model api response
                let response = ReposVCModel.ReposAPIResponse(repos: repo.items)
                self.presenter?.presentReposViewWithResponse(response: response)
            case let .failure(error):
                // if response code is 400 ... 500
                let error = ReposVCModel.ReposAPIError(error: error)
                // cache error
                self.presenter?.presentReposViewWithError(error: error)
            }
        }, onError:{ error in
            // unexpecting errors like data type error or connection issues
            let error = ReposVCModel.ReposAPIError(error: error as? ApiError ?? ApiError(message: error.localizedDescription, documentation_url: ""))
            // cache error
            self.presenter?.presentReposViewWithError(error: error)
        }).disposed(by: disposeBag)
    }
}
