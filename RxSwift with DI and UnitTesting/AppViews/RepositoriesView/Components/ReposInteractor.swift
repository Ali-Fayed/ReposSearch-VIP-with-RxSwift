//
//  ReposInteractor.swift
//  RxSwift with DI and UnitTesting
//
//  Created by Ali Fayed on 27/12/2022.
//
import RxSwift
import RxCocoa
final class HomeInteractor: ReposBusinessLogic {
    private let bag = DisposeBag()
    private let reposUseCase: FetchReposUseCase?
    var presenter: ReposPresentationLogic?
    init(reposUseCase: FetchReposUseCase?, presenter: ReposPresentationLogic?) {
        self.reposUseCase = reposUseCase
        self.presenter = presenter
    }
    func fetchRepositories(request: ReposModel.LoadRepos.Request) {
        guard let repoObservable = reposUseCase?.excute() else {return}
        repoObservable.subscribe(onNext: { result in
            switch result {
            case let .success(repo):
                // if response succedded
                let response = ReposModel.LoadRepos.ReposResponse(repos: repo.items)
                self.presenter?.presentViewData(response: response)
            case let .failure(error):
                // if response code is not 200 ... 300
                let error = ReposModel.LoadRepos.ReposAPIError(error: error)
                self.presenter?.presentHomeError(response: error)
            }
        }, onError:{ error in
            // unexpecting errors like data type error
            print("Unknown Error")
        }).disposed(by: bag)
    }
}
