//
//  ViewController.swift
//  RxSwift with DI and UnitTesting
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
    // MARK: - TableView Methods
    private func initTableView() {
        tableViewDataBinding()
        tableViewCellSelection()
        tableViewRefresh()
        tableViewPrefetch()
    }
    // MARK: - SearchController Methods
    private func initSearchController() {
        addSearchControllerInNavigationController(search: searchController, placeholder: ReposVCConstants.searchPlaceholder)
        searchBarCancelButtonClicked()
        searchBarSearchButtonClicked()
        searchBarTextDidBeginEditing()
    }
    // MARK: - State Methods
    private func handleLoadingState() {
        showActivityIndicator(activityIndicatorView: activityIndicatorView)
        interactor?.showLoading.asObservable().observe(on: MainScheduler.instance).bind(to: activityIndicatorView.rx.isAnimating).disposed(by: disposeBag)
    }
    private func handleErrorState() {
        dataSource.errorBehaviour.subscribe { [weak self] error in
            guard let self = self else { return }
            if self.dataSource.errorBehaviour.value.message != "" {
                self.showErrorAlert(title: ReposVCConstants.errorAlertTitle, message: error.message, buttonTitle: ReposVCConstants.errorButtonTitle)
            }
        }.disposed(by: disposeBag)
    }
    // MARK: - Data Methods
    func fetchRepos() {
        let request = ReposVCModel.Request()
        interactor?.fetchRepositories(request: request, page: dataSource.pageNo, query: dataSource.searchText, isPaginating: false)
    }
}
