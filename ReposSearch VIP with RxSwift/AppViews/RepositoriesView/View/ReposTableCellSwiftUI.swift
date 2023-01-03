//
//  ReposCellSwiftUI.swift
//  ReposSearch VIP with RxSwift
//
//  Created by Ali Fayed on 01/01/2023.
//
import SwiftUI
import Kingfisher
struct ReposListCell: View {
    let userAvatar: String
    let userName: String
    let repoName: String
    let repoDescription: String
    let repoStarsCount: String
    let repoLanguage: String
    let repoLanguageCircleColor: String
    var body: some View {
        ZStack(alignment: .leading) {
            Color(ReposVCConstants.darkColor)
            .cornerRadius(20, corners: .allCorners)
            HStack {
                VStack(alignment: .leading, spacing: 10) {
                    HStack {
                        KFImage(URL(string: userAvatar))
                        .resizable()
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
                            Image(systemName: ReposVCConstants.starImage).foregroundColor(.gray)
                                .scaledToFit()
                                .frame(width: 20, height: 20)
                            Text(repoStarsCount).foregroundColor(.gray).font(.system(size: 15, weight: .medium))
                                .padding(1)
                        }
                        HStack(spacing: 2) {
                            Image(systemName: ReposVCConstants.circleImage)
                                .scaledToFit()
                                .frame(width: 20, height: 20)
                                .foregroundColor(Color.random())
                            Text(repoLanguage).font(.system(size: 15, weight: .medium))
                                .padding(1)
                        }
                    }
                }
            }.padding()
          }
    }
}
