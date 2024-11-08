//
//  DetailBookView.swift
//  StudyBookApp
//
//  Created by t&a on 2024/11/08.
//

import SwiftUI

struct DetailBookView: View {
    @EnvironmentObject private var rootEnvironment: RootEnvironment
    
    private let df = DateFormatUtility()
    public let book: Book
    // dismissで実装するとCPUがオーバーフローする
    @Environment(\.presentationMode) var presentationMode
    var body: some View {
        VStack {
            HeaderView(
                leadingIcon: "chevron.backward",
                leadingAction: {
                    presentationMode.wrappedValue.dismiss()
                },
                content: {
                    Text(book.title)
                        .lineLimit(1)
                }
            )
            
            ScrollView(showsIndicators: false) {
                // 本のサムネイル
                BookThumbnailView(book: book, width: 150, height: 225)
               
                itemTextView(title: "カテゴリ", body: book.categoryId.stringValue)
                
                itemTextView(title: "タイトル", body: book.title)
                
                itemTextView(title: "著者", body: book.concatenationAuthors)
                
                itemTextView(title: "概要", body: book.desc)
                
                itemTextView(title: "登録日時", body: df.getString(date: book.createdAt))
                
                itemTextView(title: "購入金額", body: book.amount == -1 ? "ー" : "\(book.amount)円")
                
                itemTextView(title: "MEMO", body: book.memo)
            }
            
        }.navigationBarBackButtonHidden()
    }
    
    private func itemTextView(title: String, body: String) -> some View {
        VStack(spacing: 0) {
            Text(title)
                .fontS(bold: true)
                .frame(width: DeviceSizeUtility.deviceWidth - 40, alignment: .leading)
            
            Rectangle()
                .frame(width: DeviceSizeUtility.deviceWidth - 40, height: 2)
                .tint(.exText)
                .opacity(0.5)
                .padding(.vertical, 5)
                
            Text(body)
                .fontM(bold: true)
                .frame(width: DeviceSizeUtility.deviceWidth - 40, alignment: .leading)
                .textSelection(.enabled)
                .lineLimit(3)
        }.foregroundStyle(.exText)
            .padding(.bottom)
           
    }
}



#Preview {
    DetailBookView(book: Book())
        .environmentObject(RootEnvironment())
}
