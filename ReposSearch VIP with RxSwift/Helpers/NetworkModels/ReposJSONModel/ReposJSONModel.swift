//
//  ReposJSONModel.swift
//  RxSwift with DI and UnitTesting
//
//  Created by Ali Fayed on 27/12/2022.
//
import Foundation
struct Repositories: Decodable {
    let items: [Repository]
}
/// this model used to parse startted repos/repos/userrepos/search
struct Repository: Hashable {
    let repositoryName: String
    let repositoryDescription: String?
    let repositoryStars: Int?
    let repoFullName: String
    let repositoryLanguage: String?
    let repositoryURL:String
    let repoOwnerName:String
    let repoOwnerAvatarURL:String
    
enum RepositoriesCodingKeys: String, CodingKey {
        case repositoryName = "name"
        case repositoryDescription = "description"
        case repositoryStars = "stargazers_count"
        case repositoryLanguage = "language"
        case repoFullName = "full_name"
        case repositoryURL = "html_url"
        case repoOwner = "owner"
        case repoOwnerName = "login"
        case repoOwnerAvatarURL = "avatar_url"
    }
}
