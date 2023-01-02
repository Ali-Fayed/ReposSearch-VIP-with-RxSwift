//
//  ViewController.swift
//  RxSwift with DI and UnitTesting
//
//  Created by Ali Fayed on 27/12/2022.
//
import UIKit
import RxSwift
import RxCocoa
import SwiftUI
class ReposViewController: ReposViewDisplay {
    // MARK: - IBOutlets
    @IBOutlet weak private var tableView: UITableView!
    // MARK: - UI Properties
    private let refreshControl = UIRefreshControl()
    private let activityIndicatorView = UIActivityIndicatorView(style: .large)
    private let searchController = UISearchController(searchResultsController: nil)
    // MARK: - Properties
    private let disposeBag = DisposeBag()
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
        initSearchController(search: searchController, placeholder: ReposViewConstants.searchPlaceholder)
        initSearchController()
        observeOnLoading()
        observeOnError()
    }
    private func initData() {
        fetchRepos()
    }
    // MARK: - ViewController Methods
    private func fetchRepos() {
        let request = ReposModel.LoadRepos.Request()
        interactor?.fetchRepositories(request: request, page: ReposViewConstants.page, query: ReposViewConstants.baseSearchKeywoard)
    }
    private func observeOnLoading() {
        showActivityIndicator(activityIndicatorView: activityIndicatorView)
        interactor?.showLoading.asObservable().observe(on: MainScheduler.instance).bind(to: activityIndicatorView.rx.isAnimating).disposed(by: disposeBag)
    }
    private func observeOnError() {
        viewDataSource.errorSubject.subscribe { [weak self] error in
            guard let self = self else { return }
            self.showAlert(title: ReposViewConstants.errorAlertTitle, message: error.message, buttonTitle: ReposViewConstants.errorButtonTitle)
        }.disposed(by: disposeBag)
    }
    private func showAlert(title: String, message: String, buttonTitle: String) {
        let actions: [UIAlertController.AlertAction] = [ .action(title: buttonTitle, style: .destructive) ]
        UIAlertController
            .present(in: self, title: title, message: message, style: .alert, actions: actions)
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.fetchRepos()
            }).disposed(by: self.disposeBag)
    }
    // MARK: - TableView Methods
    private func initTableView() {
        tableViewDataBinding()
        tableViewSelection()
        tableViewRefresh()
        tableViewPrefetch()
    }
    private func tableViewDataBinding() {
        viewDataSource.reposSubject.bind(to: tableView.rx.items(cellIdentifier: ReposViewConstants.reposCell, cellType: UITableViewCell.self)) { row, repo, cell in
            if #available(iOS 16.0, *) {
                let hostingConfiguration = UIHostingConfiguration {
                    ReposListCell(userAvatar: repo.repoOwnerAvatarURL, userName: repo.repoOwnerName, repoName: repo.repositoryName, repoDescription: repo.repositoryDescription ?? "", repoStarsCount: "\(repo.repositoryStars ?? 1)", repoLanguage: repo.repositoryLanguage ?? "", repoLanguageCircleColor: "")
                }
                cell.contentConfiguration = hostingConfiguration
            } else {
                cell.textLabel?.text = repo.repoFullName
            }
        }.disposed(by: disposeBag)
    }
    private func tableViewSelection() {
        Observable
            .zip(tableView.rx.itemSelected, tableView.rx.modelSelected(Repository.self))
            .bind { [weak self] indexPath, repos in
                guard let self = self else { return }
                self.tableView.deselectRow(at: indexPath, animated: true)
                print(repos.repoFullName)
            }.disposed(by: disposeBag)
    }
    private func tableViewPrefetch() {
        tableView.rx.prefetchRows.subscribe(onNext: { [weak self] indexPaths in
            guard let self = self else { return }
            for indexPath in indexPaths {
                if indexPath.row == self.viewDataSource.reposData.count - 1 {
                    if self.viewDataSource.pageNo < self.viewDataSource.totalPages {
                        self.viewDataSource.pageNo += 1
                        let request = ReposModel.LoadRepos.Request()
                        self.interactor?.fetchRepositories(request: request, page: self.viewDataSource.pageNo, query: ReposViewConstants.baseSearchKeywoard)
                    }
                }
            }
        }).disposed(by: disposeBag)
    }
    private func tableViewRefresh() {
        tableView.addSubview(refreshControl)
        refreshControl.rx.controlEvent(.valueChanged).subscribe(onNext:  { [weak self] in
            guard let self = self else { return }
            self.fetchRepos()
            self.refreshControl.endRefreshing()
        }).disposed(by: disposeBag)
    }
    // MARK: - SearchController Methods
    private func initSearchController() {
        handleTextEditingSearch()
        handleCancelButtonClicked()
        handleSearchButtonClicked()
    }
    private func handleTextEditingSearch() {
        searchController.searchBar.rx.text
              .orEmpty
              .throttle(.milliseconds(500), scheduler: MainScheduler.instance)
              .distinctUntilChanged()
              .subscribe { [weak self] (query) in
                  if query != "" {
                      guard let self = self else { return }
                      self.viewDataSource.isSearching.accept(true)
                      let request = ReposModel.LoadRepos.Request()
                      self.interactor?.fetchRepositories(request: request, page: ReposViewConstants.page, query: query)
                  }
              }.disposed(by: disposeBag)
    }
    private func handleCancelButtonClicked() {
        searchController.searchBar.rx.cancelButtonClicked.subscribe { [weak self] _ in
            guard let self = self else { return }
            self.viewDataSource.isSearching.accept(false)
            self.fetchRepos()
        }.disposed(by: disposeBag)
    }
    private func handleSearchButtonClicked() {
        searchController.searchBar.rx.searchButtonClicked.subscribe { [weak self] _ in
            guard let self = self else { return }
            self.viewDataSource.isSearching.accept(false)
        }.disposed(by: disposeBag)
    }
    private func handleSearchBarTextDidBeginEditing() {
        searchController.searchBar.rx.textDidBeginEditing.subscribe(onNext: { [weak self] in
            guard let self = self else { return }
            print(self)
         }).disposed(by: disposeBag)
    }
}
