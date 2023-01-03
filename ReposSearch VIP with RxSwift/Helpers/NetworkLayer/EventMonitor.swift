//
//  NetworkLogger.swift
//  RxSwift with DI and UnitTesting
//
//  Created by Ali Fayed on 27/12/2022.
//

import Alamofire
import UIKit

class NetworkLogger: EventMonitor {
  func requestDidFinish(_ request: Request) {
    print(request.description)
  }
}
