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
    // MARK: - Props
    private let refreshControl = UIRefreshControl()
    private let bag = DisposeBag()
    var interactor: ReposBusinessLogic?
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
        initLogic()
    }
    // MARK: - Data Logic
    private func initLogic() {
        let request = ReposModel.LoadRepos.Request()
        interactor?.fetchRepositories(request: request)
    }
    // MARK: - View Logic
    private func initView() {
        initTableView()
    }
    // MARK: - TableView
    private func initTableView() {
        initTableViewCellForRowAt()
        initTableViewDidSelect()
        initTableViewRefreshControl()
    }
    private func initTableViewCellForRowAt() {
        viewDataSource.reposSubject.bind(to: tableView.rx.items(cellIdentifier: ReposViewConstants.reposCell, cellType: UITableViewCell.self)) { row, repo, cell in
            cell.textLabel?.text = repo.repoFullName
        }.disposed(by: bag)
    }
    private func initTableViewDidSelect() {
        Observable
            .zip(tableView.rx.itemSelected, tableView.rx.modelSelected(Repository.self))
            .bind { [weak self] indexPath, repos in
                guard let self = self else { return }
                self.tableView.deselectRow(at: indexPath, animated: true)
                print(repos.repoFullName)
            }.disposed(by: bag)
    }
    private func initTableViewRefreshControl() {
        refreshControl.addTarget(self, action: #selector(didPullToRefresh), for: .valueChanged)
        tableView.addSubview(refreshControl)
    }
    @objc func didPullToRefresh() {
        initLogic()
        self.refreshControl.endRefreshing()
    }
}
