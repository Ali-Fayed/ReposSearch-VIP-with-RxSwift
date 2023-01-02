//
//  CommonView.swift
//  RxSwift with DI and UnitTesting
//
//  Created by Ali Fayed on 01/01/2023.
//
import UIKit
import RxSwift
import RxCocoa
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
}
extension UIAlertController {
    struct AlertAction {
        var title: String?
        var style: UIAlertAction.Style

        static func action(title: String?, style: UIAlertAction.Style = .default) -> AlertAction {
            return AlertAction(title: title, style: style)
        }
    }
    static func present(
        in viewController: UIViewController,
        title: String?,
        message: String?,
        style: UIAlertController.Style,
        actions: [AlertAction])
        -> Observable<Int>
    {
        return Observable.create { observer in
            let alertController = UIAlertController(title: title, message: message, preferredStyle: style)

            actions.enumerated().forEach { index, action in
                let action = UIAlertAction(title: action.title, style: action.style) { _ in
                    observer.onNext(index)
                    observer.onCompleted()
                }
                alertController.addAction(action)
            }
            viewController.present(alertController, animated: true, completion: nil)
            return Disposables.create { alertController.dismiss(animated: true, completion: nil) }
        }
    }
}
