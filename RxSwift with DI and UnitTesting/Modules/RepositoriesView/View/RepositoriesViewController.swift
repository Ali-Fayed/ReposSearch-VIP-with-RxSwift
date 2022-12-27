//
//  ViewController.swift
//  RxSwift with DI and UnitTesting
//
//  Created by Ali Fayed on 27/12/2022.
//

import UIKit
import RxSwift
import RxCocoa
class RepositoriesViewController: ReposDisplay {
    @IBOutlet weak var tableView: UITableView!
    private let refreshControl = UIRefreshControl()
    private let bag = DisposeBag()
    var interactor: ReposBusinessLogic?
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
        initLogic()
    }
    private func initLogic() {
        let request = ReposModel.LoadRepos.Request()
        interactor?.fetchRepositories(request: request)
    }
    private func initView() {
        initTableView()
    }
    private func initTableView() {
        initTableViewCellForRowAt()
        initTableViewDidSelect()
        initTableViewRefreshControl()
    }
    private func initTableViewCellForRowAt() {
        dataSource.reposSubject.bind(to: tableView.rx.items(cellIdentifier: "cell", cellType: UITableViewCell.self)) { row, item, cell in
            cell.textLabel?.text = item.repoFullName
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
