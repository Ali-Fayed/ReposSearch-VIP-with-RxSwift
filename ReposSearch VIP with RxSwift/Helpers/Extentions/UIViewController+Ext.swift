//
//  CommonView.swift
//  ReposSearch VIP with RxSwift
//
//  Created by Ali Fayed on 01/01/2023.
//
import UIKit
extension UIViewController {
    func showActivityIndicator(activityIndicatorView: UIActivityIndicatorView) {
        self.view.addSubview(activityIndicatorView)
        activityIndicatorView.center = self.view.center
        activityIndicatorView.startAnimating()
    }
    func addSearchControllerInNavigationController (search: UISearchController, placeholder: String) {
        search.obscuresBackgroundDuringPresentation = false
        search.hidesNavigationBarDuringPresentation = true
        navigationItem.hidesSearchBarWhenScrolling = false
        definesPresentationContext = true
        search.searchBar.placeholder = placeholder
        navigationItem.searchController = search
    }
    func shotTableViewFooterLoadingIndicatorView(tableView: UITableView) {
        let spinner = UIActivityIndicatorView(style: .medium)
        spinner.startAnimating()
        spinner.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: tableView.bounds.width, height: CGFloat(44))
        tableView.tableFooterView = spinner
        tableView.tableFooterView?.isHidden = false
    }
}
