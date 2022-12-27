//
//  NetwrokReachability.swift
//  RxSwift with DI and UnitTesting
//
//  Created by Ali Fayed on 27/12/2022.
//

import UIKit
import Alamofire

class NetwrokReachability {
    
    static let shared = NetwrokReachability()
    let reachabilityManager = NetworkReachabilityManager(host: "www.google.com")
    let offlineAlertController: UIAlertController = {
        let alert = UIAlertController(title: "Internet Error", message: "Internet Error" , preferredStyle: .alert)
        let action = UIAlertAction(title: "Try Again", style: .default) {_ in
            DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                NetwrokReachability.shared.retryOnce()
            }
        }
        alert.addAction(action)
        return alert
    }()
    
    let connectionFailed: UIAlertController = {
        let alert = UIAlertController(title: "No Internet", message:  "You are now in offline mode" , preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default) {_ in
         
        }
        alert.addAction(action)
        return alert
    }()
    
    func startNetworkMonitoring() {
        reachabilityManager?.startListening { status in
            switch status {
            case .notReachable:
                self.showOfflineAlert()
            case .reachable(.cellular):
                self.dismissOfflineAlert()
            case .reachable(.ethernetOrWiFi):
                self.dismissOfflineAlert()
            case .unknown:
                print("Unknown state")
            }
        }
    }
    
    func retryOnce() {
        reachabilityManager?.startListening { status in
            switch status {
            case .notReachable:
                self.show()
            case .reachable(.cellular):
                self.dismissOfflineAlert()
            case .reachable(.ethernetOrWiFi):
                self.dismissOfflineAlert()
            case .unknown:
                print("Unknown state")
            }
        }
    }
    
    func showOfflineAlert() {
        let rootViewController = UIApplication.shared.windows.first?.rootViewController
        rootViewController?.present(offlineAlertController, animated: true, completion: nil)
    }
    
    func show() {
        let rootViewController = UIApplication.shared.windows.first?.rootViewController
        rootViewController?.present(connectionFailed, animated: true, completion: nil)
    }
    
    func dismissOfflineAlert() {
        let rootViewController = UIApplication.shared.windows.first?.rootViewController
        rootViewController?.dismiss(animated: true, completion: nil)
    }
}
