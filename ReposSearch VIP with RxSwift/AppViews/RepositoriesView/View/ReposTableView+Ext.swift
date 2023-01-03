//
//  ReposTableView+Ext.swift
//  RxSwift with DI and UnitTesting
//
//  Created by Ali Fayed on 02/01/2023.
//
import UIKit
import RxSwift
import SwiftUI
import SafariServices
extension ReposViewController {
    // MARK: - TableView Methods
    func tableViewDataBinding() {
        /// bind data from publishSubject to tableView this like cellForRowAt method
        dataSource.reposSubject.bind(to: tableView.rx.items(cellIdentifier: ReposVCConstants.cellIdentifier, cellType: UITableViewCell.self)) { [weak self] row, repo, cell in
            guard let self = self else { return }
            /// iOS 16 new feature let us write swiftu view as a tableViewCell
            if #available(iOS 16.0, *) {
                let hostingConfiguration = UIHostingConfiguration {
                    self.reposCellSwiftUI(repo: repo)
                }
                cell.contentConfiguration = hostingConfiguration
            } else {
                /// normal case us basic label only
                cell.textLabel?.text = repo.repoFullName
            }
        }.disposed(by: disposeBag)
    }
    func tableViewCellSelection() {
        /// zip two observables to retrieve item and model selection
        Observable
            .zip(tableView.rx.itemSelected, tableView.rx.modelSelected(Repository.self))
            .bind { [weak self] indexPath, repos in
                guard let self = self else { return }
                self.tableView.deselectRow(at: indexPath, animated: true)
                self.openRepoInSafari(url: repos.repositoryURL)
            }.disposed(by: disposeBag)
    }
    func tableViewPrefetch() {
        /// this let us prefetch data for tableView for infinte scrolling behaviour
        tableView.rx.prefetchRows.subscribe(onNext: { [weak self] indexPaths in
            guard let self = self else { return }
            if self.dataSource.isSearching.value == false {
                /// check if not searching to load more in the normal condition
                self.fetchMoreRepos(indexPaths: indexPaths)
            }
        }).disposed(by: disposeBag)
    }
    func tableViewRefresh() {
        tableView.addSubview(refreshControl)
        /// refresh tableView when need by this one that fetch the original swift repos
        refreshControl.rx.controlEvent(.valueChanged).subscribe(onNext:  { [weak self] in
            guard let self = self else { return }
            self.fetchRepos()
            self.refreshControl.endRefreshing()
        }).disposed(by: disposeBag)
    }
    // MARK: - Other Methods
    func reposCellSwiftUI(repo: Repository) -> some View {
        /// swiftui cell for reposTableView
        return ReposListCell(userAvatar: repo.repoOwnerAvatarURL, userName: repo.repoOwnerName, repoName: repo.repositoryName, repoDescription: repo.repositoryDescription ?? "", repoStarsCount: "\(repo.repositoryStars ?? 1)", repoLanguage: repo.repositoryLanguage ?? "", repoLanguageCircleColor: "")
    }
    func openRepoInSafari(url: String) {
        /// open link in safariVC
        if let url = URL(string: url) {
              let config = SFSafariViewController.Configuration()
              config.entersReaderIfAvailable = true
              let vc = SFSafariViewController(url: url, configuration: config)
              self.present(vc, animated: true)
           }
    }
    func fetchMoreRepos(indexPaths: [IndexPath]) {
        /// add new page every time we reach the last item in the tableView and load more data
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
