//
//  ReposTableView+Ext.swift
//  RxSwift with DI and UnitTesting
//
//  Created by Ali Fayed on 02/01/2023.
//
import UIKit
import RxSwift
import SwiftUI
extension ReposViewController {
    // MARK: - TableView Methods
    func tableViewDataBinding() {
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
    func tableViewCellSelection() {
        Observable
            .zip(tableView.rx.itemSelected, tableView.rx.modelSelected(Repository.self))
            .bind { [weak self] indexPath, repos in
                guard let self = self else { return }
                self.tableView.deselectRow(at: indexPath, animated: true)
            }.disposed(by: disposeBag)
    }
    func tableViewPrefetch() {
        tableView.rx.prefetchRows.subscribe(onNext: { [weak self] indexPaths in
            guard let self = self else { return }
            if self.dataSource.isSearching.value == false {
                self.fetchMoreRepos(indexPaths: indexPaths)
            }
        }).disposed(by: disposeBag)
    }
    func tableViewRefresh() {
        tableView.addSubview(refreshControl)
        refreshControl.rx.controlEvent(.valueChanged).subscribe(onNext:  { [weak self] in
            guard let self = self else { return }
            self.fetchRepos()
            self.refreshControl.endRefreshing()
        }).disposed(by: disposeBag)
    }
    // MARK: - Other Methods
    func reposCellSwiftUI(repo: Repository) -> some View {
        return ReposListCell(userAvatar: repo.repoOwnerAvatarURL, userName: repo.repoOwnerName, repoName: repo.repositoryName, repoDescription: repo.repositoryDescription ?? "", repoStarsCount: "\(repo.repositoryStars ?? 1)", repoLanguage: repo.repositoryLanguage ?? "", repoLanguageCircleColor: "")
    }
    func fetchMoreRepos(indexPaths: [IndexPath]) {
        for indexPath in indexPaths {
            if indexPath.row == self.dataSource.reposData.count - 1 {
                if self.dataSource.pageNo < self.dataSource.totalPages {
                    self.dataSource.pageNo += 1
                    self.shotTableViewFooterLoadingIndicatorView(tableView: tableView)
                    let request = ReposVCModel.Request()
                    self.interactor?.fetchRepositories(request: request, page: self.dataSource.pageNo, query: dataSource.searchText, isPaginating: true)
                }
            }
        }
    }
}
