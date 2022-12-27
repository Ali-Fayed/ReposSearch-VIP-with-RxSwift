//
//  RequestIntercptor.swift
//  RxSwift with DI and UnitTesting
//
//  Created by Ali Fayed on 27/12/2022.
//

import Alamofire
import Foundation

class RequestIntercptor: RequestInterceptor {
  let retryLimit = 5
  let retryDelay: TimeInterval = 10
  func retry(_ request: Request, for session: Session, dueTo error: Error, completion: @escaping (RetryResult) -> Void) {
    let response = request.task?.response as? HTTPURLResponse
    // Retry for 5xx status codes
    if
      let statusCode = response?.statusCode,
      (500...599).contains(statusCode),
      request.retryCount < retryLimit {
        completion(.retryWithDelay(retryDelay))
    } else {
      return completion(.doNotRetry)
    }
  }

}
