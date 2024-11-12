//
//  SettingView.swift
//  StudyBookApp
//
//  Created by t&a on 2024/11/12.
//

import SwiftUI

struct SettingView: View {

    private var viewModel = SettingViewModel()
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack(spacing: 0) {
            
            HStack {
                
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "chevron.backward")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 15, height: 15)
                        .padding(8)
                        .fontWeight(.bold)
                        .foregroundStyle(.white)
                        .background(.themaBlack)
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                }
                
                Spacer()
                
                Text(L10n.settingTitle)
                    .foregroundStyle(.exText)
                    .fontWeight(.bold)
                
                Spacer()
                
                Spacer()
                    .frame(width: 15, height: 15)
                    .padding(8)
                
            }.padding(.horizontal)
                .padding(.top)
            
            List {
                Section(header: Text("Link"), footer: Text(L10n.settingSectionLinkDesc)) {
//                    if let url = URL(string: StaticUrls.APP_REVIEW_URL) {
//                        // 1:レビューページ
//                        Link(destination: url, label: {
//                            HStack {
//                                Image(systemName: "hand.thumbsup")
//                                Text(L10n.settingSectionLinkReview)
//                            }.foregroundStyle(.white)
//                        }).listRowBackground(Color.themaBlack)
//                    }
                    
                    // 2:シェアボタン
                    Button {
                        viewModel.shareApp(
                            shareText: L10n.settingSectionLinkShareText,
                            shareLink: StaticUrls.APP_REVIEW_URL
                        )
                    } label: {
                        HStack {
                            Image(systemName: "star.bubble")
                            
                            Text(L10n.settingSectionLinkRecommend)
                        }.foregroundStyle(.white)
                    }.listRowBackground(Color.themaBlack)
                    
                    if let url = URL(string: StaticUrls.APP_CONTACT_URL) {
                        // 3:お問い合わせフォーム
                        Link(destination: url, label: {
                            HStack {
                                Image(systemName: "paperplane")
                                Text(L10n.settingSectionLinkContact)
                                Image(systemName: "link").font(.caption)
                            }.foregroundStyle(.white)
                        }).listRowBackground(Color.themaBlack)
                    }
                    
                    if let url = URL(string: StaticUrls.APP_TERMS_OF_SERVICE_URL) {
                        // 4:利用規約とプライバシーポリシー
                        Link(destination: url, label: {
                            HStack {
                                Image(systemName: "note.text")
                                Text(L10n.settingSectionLinkTerms)
                                Image(systemName: "link").font(.caption)
                            }.foregroundStyle(.white)
                        }).listRowBackground(Color.themaBlack)
                    }
                }
            }.scrollContentBackground(.hidden)
                .background(.white)
            
        }.foregroundStyle(.exText)
            .navigationBarBackButtonHidden()
    }
}

#Preview {
    SettingView()
}

