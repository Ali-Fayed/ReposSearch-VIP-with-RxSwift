//
//  ViewController.swift
//  ReposSearch VIP with RxSwift
//
//  Created by Ali Fayed on 27/12/2022.
//
import UIKit
import RxSwift
class ReposViewController: ReposViewDisplay {
    // MARK: - IBOutlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchPlaceholderLabel: UILabel!
    // MARK: - UI Properties
    let refreshControl = UIRefreshControl()
    let activityIndicatorView = UIActivityIndicatorView(style: .large)
    let searchController = UISearchController(searchResultsController: nil)
    // MARK: - Properties
    let disposeBag = DisposeBag()
    var interactor: ReposBusinessLogic?
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
        initData()
        initStates()
    }
    // MARK: - Main ViewController Methods
    private func initView() {
        /// add any UIView methods here
        initTableView()
        initSearchController()
    }
    private func initStates() {
        /// add any state methods here
        handleLoadingState()
        handleErrorState()
    }
    private func initData() {
        /// add any data methods here
        fetchRepos()
    }
    // MARK: - TableView Methods
    private func initTableView() {
        /// add any tableView configurations here
        tableViewDataBinding()
        tableViewCellSelection()
        tableViewRefresh()
        tableViewPrefetch()
    }
    // MARK: - SearchController Methods
    private func initSearchController() {
        /// add any searchController configurations here
        addSearchControllerInNavigationController(search: searchController, placeholder: ReposVCConstants.searchPlaceholder)
        searchBarCancelButtonClicked()
        searchBarSearchButtonClicked()
        searchBarTextDidBeginEditing()
    }
    // MARK: - State Methods
    private func handleLoadingState() {
        /// handle loading state to show loading indicator at the start
        showActivityIndicator(activityIndicatorView: activityIndicatorView)
        interactor?.showLoading.asObservable().observe(on: MainScheduler.instance).bind(to: activityIndicatorView.rx.isAnimating).disposed(by: disposeBag)
    }
    private func handleErrorState() {
        /// show alert when api request return with error
        dataSource.errorBehaviour.subscribe { [weak self] error in
            guard let self = self else { return }
            if self.dataSource.errorBehaviour.value.message != "" {
                self.showErrorAlert(title: ReposVCConstants.errorAlertTitle, message: error.message, buttonTitle: ReposVCConstants.errorButtonTitle)
            }
        }.disposed(by: disposeBag)
    }
    // MARK: - Data Methods
    func fetchRepos() {
        /// fetch repos from interactor
        let request = ReposVCModel.Request()
        interactor?.fetchRepositories(request: request, page: dataSource.pageNo, query: dataSource.searchText, isPaginating: false)
    }
}
