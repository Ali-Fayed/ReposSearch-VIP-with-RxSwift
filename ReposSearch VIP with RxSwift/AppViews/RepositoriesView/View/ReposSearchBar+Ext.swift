//
//  ReposSearchBar+Ext.swift
//  ReposSearch VIP with RxSwift
//
//  Created by Ali Fayed on 02/01/2023.
//
import RxSwift
import RxCocoa
import UIKit
extension ReposViewController {
    // MARK: - SearchController Methods
    func searchBarSearchButtonClicked() {
        /// that delegate method with rx handle when we click search on keyboard, this hide tableView and display the placholder label for better UX.
        searchController.searchBar.rx.searchButtonClicked.subscribe { [weak self] _ in
            guard let self = self else { return }
            guard let searchText = self.searchController.searchBar.text else {return}
            self.tableView.isHidden = false
            self.searchPlaceholderLabel.isHidden = true
            self.dataSource.isSearching.accept(false)
            self.searchForRepos(query: searchText)
        }.disposed(by: disposeBag)
    }
    func searchBarCancelButtonClicked() {
        /// cancel button that reset the normal conditon before search
        searchController.searchBar.rx.cancelButtonClicked.subscribe { [weak self] _ in
            guard let self = self else { return }
            self.tableView.isHidden = false
            self.searchPlaceholderLabel.isHidden = true
            self.dataSource.isSearching.accept(false)
        }.disposed(by: disposeBag)
    }
    func searchBarTextDidBeginEditing() {
        /// this method is run when we make an interaction with the searchBar
        searchController.searchBar.rx.textDidBeginEditing.subscribe(onNext: { [weak self] in
            guard let self = self else { return }
            self.tableView.isHidden = true
            self.searchPlaceholderLabel.isHidden = false
         }).disposed(by: disposeBag)
    }
    func showErrorAlert(title: String, message: String, buttonTitle: String) {
        /// generic error Alert recieve the error message from API
        let actions: [UIAlertController.AlertAction] = [ .action(title: buttonTitle, style: .destructive) ]
        UIAlertController
            .present(in: self, title: title, message: message, style: .alert, actions: actions)
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.fetchRepos()
            }).disposed(by: self.disposeBag)
    }
    // MARK: - Other Methods
    func searchForRepos(query: String) {
        self.tableView.isHidden = false
        self.searchPlaceholderLabel.isHidden = true
        self.dataSource.isSearching.accept(true)
        let request = ReposVCModel.Request()
        self.interactor?.fetchRepositories(request: request, page: dataSource.pageNo, query: query, isPaginating: false)
    }
}
