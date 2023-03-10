//
//  ReposTableView+Ext.swift
//  ReposSearch VIP with RxSwift
//
//  Created by Ali Fayed on 02/01/2023.
//
import UIKit
import RxSwift
import SwiftUI
import RxDataSources
extension ReposViewController {
    // MARK: - TableView Methods
    func tableViewDataBinding() {
        /// bind data from observale to tableView this like cellForRowAt method with rxData source if we need a sections
        dataSource.reposListObservable.bind(to: tableView.rx.items(dataSource: tableViewDataSource())).disposed(by: disposeBag)
    }
    func tableViewCellSelection() {
        /// zip two observables to retrieve item and model selection
        Observable
            .zip(tableView.rx.itemSelected, tableView.rx.modelSelected(Repository.self))
            .bind { [weak self] indexPath, repos in
                guard let self = self else { return }
                self.tableView.deselectRow(at: indexPath, animated: true)
                self.dataSource.router?.trigger(.safariView(url: repos.repositoryURL))
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
    func tableViewDataSource() -> RxTableViewSectionedReloadDataSource<ReposSectionModel> {
        /// handle tableView data source with sections
        let tableViewDataSource = RxTableViewSectionedReloadDataSource<ReposSectionModel>(
            configureCell: { (_ , tableView, indexPath, repo) in
                let cell = tableView.dequeueReusableCell(withIdentifier: ReposVCConstants.cellIdentifier, for: indexPath)
                if #available(iOS 16.0, *) {
                    let hostingConfiguration = UIHostingConfiguration {
                        self.reposCellSwiftUI(repo: repo)
                    }
                    cell.contentConfiguration = hostingConfiguration
                } else {
                    /// normal case us basic label only
                    cell.textLabel?.text = repo.repoFullName
                }
                return cell
            },
            /// section handling
            titleForHeaderInSection: { dataSource, sectionIndex in
                return dataSource[sectionIndex].header
            }
        )
        return tableViewDataSource
    }
    func reposCellSwiftUI(repo: Repository) -> some View {
        /// swiftui cell for reposTableView
        return ReposListCell(userAvatar: repo.repoOwnerAvatarURL, userName: repo.repoOwnerName, repoName: repo.repositoryName, repoDescription: repo.repositoryDescription ?? "", repoStarsCount: "\(repo.repositoryStars ?? 1)", repoLanguage: repo.repositoryLanguage ?? "", repoLanguageCircleColor: "")
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
