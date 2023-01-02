//
//  ViewController.swift
//  RxSwift with DI and UnitTesting
//
//  Created by Ali Fayed on 27/12/2022.
//
import UIKit
import RxSwift
import SwiftUI
class ReposViewController: ReposViewDisplay {
    // MARK: - IBOutlets
    @IBOutlet weak private var tableView: UITableView!
    @IBOutlet weak private var searchPlaceholderLabel: UILabel!
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
        initStates()
    }
    // MARK: - Main Methods
    private func initView() {
        initTableView()
        initSearchController()
    }
    private func initStates() {
        handleLoadingState()
        handleErrorState()
    }
    private func initData() {
        fetchRepos()
    }
    // MARK: - State Methods
    private func handleLoadingState() {
        showActivityIndicator(activityIndicatorView: activityIndicatorView)
        interactor?.showLoading.asObservable().observe(on: MainScheduler.instance).bind(to: activityIndicatorView.rx.isAnimating).disposed(by: disposeBag)
    }
    private func handleErrorState() {
        dataSource.errorSubject.subscribe { [weak self] error in
            guard let self = self else { return }
            self.showErrorAlert(title: ReposVCConstants.errorAlertTitle, message: error.message, buttonTitle: ReposVCConstants.errorButtonTitle)
        }.disposed(by: disposeBag)
    }
    // MARK: - Data Methods
    private func fetchRepos() {
        let request = ReposVCModel.Request()
        interactor?.fetchRepositories(request: request, page: ReposVCConstants.page, query: dataSource.baseSearchKeywoard)
    }
    private func fetchMoreRepos(indexPaths: [IndexPath]) {
        for indexPath in indexPaths {
            if indexPath.row == self.dataSource.reposData.count - 1 {
                if self.dataSource.pageNo < self.dataSource.totalPages {
                    self.dataSource.pageNo += 1
                    let request = ReposVCModel.Request()
                    self.interactor?.fetchRepositories(request: request, page: self.dataSource.pageNo, query: dataSource.baseSearchKeywoard)
                }
            }
        }
    }
    private func searchForRepos(query: String) {
        self.tableView.isHidden = false
        self.searchPlaceholderLabel.isHidden = true
        self.dataSource.isSearching.accept(true)
        let request = ReposVCModel.Request()
        self.interactor?.fetchRepositories(request: request, page: ReposVCConstants.page, query: query)
    }
    // MARK: - TableView Methods
    private func initTableView() {
        tableViewDataBinding()
        tableViewCellSelection()
        tableViewRefresh()
        tableViewPrefetch()
    }
    private func tableViewDataBinding() {
        dataSource.reposSubject.bind(to: tableView.rx.items(cellIdentifier: ReposVCConstants.cellIdentifier, cellType: UITableViewCell.self)) { [weak self] row, repo, cell in
            guard let self = self else { return }
            if #available(iOS 16.0, *) {
                let hostingConfiguration = UIHostingConfiguration {
                    self.reposCellSwiftUI(repo: repo)
                }
                cell.contentConfiguration = hostingConfiguration
            } else {
                cell.textLabel?.text = repo.repoFullName
            }
        }.disposed(by: disposeBag)
    }
    private func tableViewCellSelection() {
        Observable
            .zip(tableView.rx.itemSelected, tableView.rx.modelSelected(Repository.self))
            .bind { [weak self] indexPath, repos in
                guard let self = self else { return }
                self.tableView.deselectRow(at: indexPath, animated: true)
            }.disposed(by: disposeBag)
    }
    private func tableViewPrefetch() {
        tableView.rx.prefetchRows.subscribe(onNext: { [weak self] indexPaths in
            guard let self = self else { return }
            self.fetchMoreRepos(indexPaths: indexPaths)
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
        addSearchControllerInNavigationController(search: searchController, placeholder: ReposVCConstants.searchPlaceholder)
        searchBarTextEditing()
        searchBarCancelButtonClicked()
        searchBarSearchButtonClicked()
        searchBarTextDidBeginEditing()
    }
    private func searchBarTextEditing() {
        searchController.searchBar.rx.text
              .orEmpty
              .throttle(.milliseconds(500), scheduler: MainScheduler.instance)
              .distinctUntilChanged()
              .subscribe { [weak self] (query) in
                  if query != "" {
                      guard let self = self else { return }
                      self.searchForRepos(query: query)
                  }
              }.disposed(by: disposeBag)
    }
    private func searchBarCancelButtonClicked() {
        searchController.searchBar.rx.cancelButtonClicked.subscribe { [weak self] _ in
            guard let self = self else { return }
            self.dataSource.isSearching.accept(false)
            self.tableView.isHidden = false
            self.searchPlaceholderLabel.isHidden = true
            self.fetchRepos()
        }.disposed(by: disposeBag)
    }
    private func searchBarSearchButtonClicked() {
        searchController.searchBar.rx.searchButtonClicked.subscribe { [weak self] _ in
            guard let self = self else { return }
            self.tableView.isHidden = false
            self.searchPlaceholderLabel.isHidden = true
            self.dataSource.isSearching.accept(false)
        }.disposed(by: disposeBag)
    }
    private func searchBarTextDidBeginEditing() {
        searchController.searchBar.rx.textDidBeginEditing.subscribe(onNext: { [weak self] in
            guard let self = self else { return }
            self.tableView.isHidden = true
            self.searchPlaceholderLabel.isHidden = false
         }).disposed(by: disposeBag)
    }
    // MARK: - Other UI Methods
    private func reposCellSwiftUI(repo: Repository) -> some View {
        return ReposListCell(userAvatar: repo.repoOwnerAvatarURL, userName: repo.repoOwnerName, repoName: repo.repositoryName, repoDescription: repo.repositoryDescription ?? "", repoStarsCount: "\(repo.repositoryStars ?? 1)", repoLanguage: repo.repositoryLanguage ?? "", repoLanguageCircleColor: "")
    }
    private func showErrorAlert(title: String, message: String, buttonTitle: String) {
        let actions: [UIAlertController.AlertAction] = [ .action(title: buttonTitle, style: .destructive) ]
        UIAlertController
            .present(in: self, title: title, message: message, style: .alert, actions: actions)
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.fetchRepos()
            }).disposed(by: self.disposeBag)
    }
}
