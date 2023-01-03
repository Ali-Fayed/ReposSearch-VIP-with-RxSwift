//
//  RequestRouter.swift
//  ReposSearch VIP with RxSwift
//
//  Created by Ali Fayed on 27/12/2022.
//
import Alamofire
import Foundation
enum RequestRouter {
    case searchRepos(page: Int, query: String)
    var baseURL: String {
        switch self {
        case .searchRepos:
            return "https://api.github.com"
        }
    }
    var method: HTTPMethod {
        switch self {
        case .searchRepos:
            return .get
        }
    }
    var path: String {
        switch self {
        case .searchRepos:
            return "/search/repositories"
        }
    }
    var parameters: [String: String]? {
        switch self {
        case .searchRepos(let page, let query):
            return ["per_page": "30", "sort": "stars", "order": "desc", "page": "\(page)" , "q": query]
        }
    }
}
// MARK: - URLRequestConvertible
extension RequestRouter: URLRequestConvertible {
    func asURLRequest() throws -> URLRequest {
        let requestURL = try baseURL.asURL().appendingPathComponent(path)
        var request = URLRequest(url: requestURL)
        request.method = method
        if method == .get {
            request = try URLEncodedFormParameterEncoder().encode(parameters, into: request)
        }
        return request
    }
}
