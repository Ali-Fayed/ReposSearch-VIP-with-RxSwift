//
//  ReposViewSectionModel.swift
//  ReposSearch VIP with RxSwift
//
//  Created by Ali Fayed on 03/01/2023.
//
import Foundation
import RxDataSources
struct ReposSectionModel {
    var header: String
    var items: [Repository]
}
extension ReposSectionModel: SectionModelType {
    init(original: ReposSectionModel, items: [Repository]) {
        self = original
        self.items = items
    }
}
