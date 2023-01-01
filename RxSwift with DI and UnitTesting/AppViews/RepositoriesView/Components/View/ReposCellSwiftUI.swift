//
//  ReposCellSwiftUI.swift
//  RxSwift with DI and UnitTesting
//
//  Created by Ali Fayed on 01/01/2023.
//
import SwiftUI
struct ReposListCell: View {
    let userAvatar: String
    let userName: String
    let repoName: String
    let repoDescription: String
    let repoStarsCount: String
    let repoLanguage: String
    let repoLanguageCircleColor: String
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    AsyncImage(url: URL(string: userAvatar)!,
                                  placeholder: { ProgressView() },
                                  image: { Image(uiImage: $0).resizable() })
                    .frame(width: 30, height: 30)
                    .cornerRadius(25, corners: .allCorners)
                     Text(userName)
                        .font(.system(size: 15, weight: .medium))
                        .padding(2)
                }
                Text(repoName)
                    .padding(1)
                    .font(.system(size: 19, weight: .bold))
                Text(repoDescription)
                    .font(.system(size: 14, weight: .medium))
                    .padding(1)
                HStack(spacing: 10) {
                    HStack(spacing: 2) {
                        Image(systemName: "star.fill").foregroundColor(.gray)
                            .scaledToFit()
                            .frame(width: 20, height: 20)
                        Text(repoStarsCount).foregroundColor(.gray).font(.system(size: 15, weight: .medium))
                            .padding(1)
                    }
                    HStack(spacing: 2) {
                        Image(systemName: "circle.fill")
                            .scaledToFit()
                            .frame(width: 20, height: 20)
                            .foregroundColor(Color.random())
                        Text(repoLanguage).font(.system(size: 15, weight: .medium))

                            .padding(1)
                    }
                }
            }
        }
    }
}
