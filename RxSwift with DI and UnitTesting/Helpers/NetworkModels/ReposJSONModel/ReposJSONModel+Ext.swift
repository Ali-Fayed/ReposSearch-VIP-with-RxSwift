//
//  ReposJSONModel+Ext.swift
//  RxSwift with DI and UnitTesting
//
//  Created by Ali Fayed on 27/12/2022.
//
import Foundation
extension Repository: Decodable {
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: RepositoriesCodingKeys.self)
        let owner = try container.nestedContainer(keyedBy: RepositoriesCodingKeys.self, forKey: .repoOwner)
        repositoryName = try container.decode(String.self, forKey: .repositoryName)
        repositoryDescription = try? container.decode(String.self, forKey: .repositoryDescription)
        repositoryStars = try? container.decode(Int.self, forKey: .repositoryStars)
        repositoryLanguage = try? container.decode(String.self, forKey: .repositoryLanguage)
        repositoryURL = try container.decode(String.self, forKey: .repositoryURL)
        repoFullName = try container.decode(String.self, forKey: .repoFullName)
        repoOwnerName = try owner.decode(String.self, forKey: .repoOwnerName)
        repoOwnerAvatarURL = try owner.decode(String.self, forKey: .repoOwnerAvatarURL)
    }
}
