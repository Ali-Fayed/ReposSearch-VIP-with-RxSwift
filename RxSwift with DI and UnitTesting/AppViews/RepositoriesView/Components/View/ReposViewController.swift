//
//  ViewController.swift
//  RxSwift with DI and UnitTesting
//
//  Created by Ali Fayed on 27/12/2022.
//
import UIKit
import RxSwift
import RxCocoa
class ReposViewController: ReposViewDisplay {
    // MARK: - IBOutlets
    @IBOutlet weak private var tableView: UITableView!
    // MARK: - UI Properties
    private let refreshControl = UIRefreshControl()
    private let activityIndicatorView = UIActivityIndicatorView(style: .large)
    // MARK: - Properties
    private let disposeBage = DisposeBag()
    var interactor: ReposBusinessLogic?
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
        initData()
    }
    // MARK: - Main Methods
    private func initView() {
        initTableView()
        observeOnLoading()
        observeOnError()
    }
    private func initData() {
        fetchRepos()
    }
    // MARK: - View Methods
    private func fetchRepos() {
        let request = ReposModel.LoadRepos.Request()
        interactor?.fetchRepositories(request: request)
    }
    private func observeOnLoading() {
        showActivityIndicator(activityIndicatorView: activityIndicatorView)
        interactor?.showLoading.asObservable().observe(on: MainScheduler.instance).bind(to: activityIndicatorView.rx.isAnimating).disposed(by: disposeBage)
    }
    private func observeOnError() {
        viewDataSource.errorSubject.subscribe { [weak self] error in
            guard let self = self else { return }
            self.showAlert(title: ReposViewConstants.errorAlertTitle, message: error.message, buttonTitle: ReposViewConstants.errorButtonTitle)
        }.disposed(by: disposeBage)
    }
    private func showAlert(title: String, message: String, buttonTitle: String) {
        let actions: [UIAlertController.AlertAction] = [ .action(title: buttonTitle, style: .destructive) ]
        UIAlertController
            .present(in: self, title: title, message: message, style: .alert, actions: actions)
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.fetchRepos()
            }).disposed(by: self.disposeBage)
    }
    // MARK: - TableView
    private func initTableView() {
        tableViewDataBinding()
        tableViewSelection()
        tableViewRefresh()
    }
    private func tableViewDataBinding() {
        viewDataSource.reposSubject.bind(to: tableView.rx.items(cellIdentifier: ReposViewConstants.reposCell, cellType: UITableViewCell.self)) { row, repo, cell in
            cell.textLabel?.text = repo.repoFullName
        }.disposed(by: disposeBage)
    }
    private func tableViewSelection() {
        Observable
            .zip(tableView.rx.itemSelected, tableView.rx.modelSelected(Repository.self))
            .bind { [weak self] indexPath, repos in
                guard let self = self else { return }
                self.tableView.deselectRow(at: indexPath, animated: true)
                print(repos.repoFullName)
            }.disposed(by: disposeBage)
    }
    private func tableViewRefresh() {
        tableView.addSubview(refreshControl)
        refreshControl.rx.controlEvent(.valueChanged).subscribe(onNext:  { [weak self] in
            guard let self = self else { return }
            self.fetchRepos()
            self.refreshControl.endRefreshing()
        }).disposed(by: disposeBage)
    }
}
