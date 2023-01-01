//
//  ReposInteractor.swift
//  RxSwift with DI and UnitTesting
//
//  Created by Ali Fayed on 27/12/2022.
//
import RxSwift
import RxCocoa
final class HomeInteractor: ReposBusinessLogic {
    private let disposeBage = DisposeBag()
    private let reposUseCase: FetchReposUseCase?
    typealias request = ReposModel.LoadRepos.Request
    var showLoading = BehaviorRelay<Bool>(value: false)
    var presenter: ReposPresentationLogic?
    init(reposUseCase: FetchReposUseCase?, presenter: ReposPresentationLogic?) {
        self.reposUseCase = reposUseCase
        self.presenter = presenter
    }
    func fetchRepositories(request: request) {
        showLoading.accept(true)
        guard let repoObservable = reposUseCase?.excute() else {return}
        repoObservable.subscribe(onNext: { result in
            switch result {
            case let .success(repo):
                // if response succedded
                self.showLoading.accept(false)
                let response = ReposModel.LoadRepos.ReposResponse(repos: repo.items)
                self.presenter?.presentViewData(response: response)
            case let .failure(error):
                // if response code is not 200 ... 300
                let error = ReposModel.LoadRepos.ReposAPIError(error: error)
                self.presenter?.presentRepoError(response: error)
            }
        }, onError:{ error in
            // unexpecting errors like data type error
            let error = ReposModel.LoadRepos.ReposAPIError(error: error)
            self.presenter?.presentRepoError(response: error)
        }).disposed(by: disposeBage)
    }
}
