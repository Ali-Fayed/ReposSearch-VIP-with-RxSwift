//
//  NetworkLogger.swift
//  ReposSearch VIP with RxSwift
//
//  Created by Ali Fayed on 27/12/2022.
//
import Alamofire
class NetworkLogger: EventMonitor {
  func requestDidFinish(_ request: Request) {
    print(request.description)
  }
}
