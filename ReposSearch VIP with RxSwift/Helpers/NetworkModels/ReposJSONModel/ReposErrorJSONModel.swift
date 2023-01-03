//
//  ReposErrorJSONModel.swift
//  ReposSearch VIP with RxSwift
//
//  Created by Ali Fayed on 01/01/2023.
//

import Foundation
struct ApiError: Codable, Error {
   let message: String
   let documentation_url: String
}
