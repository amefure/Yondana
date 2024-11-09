//
//  DetailBookView.swift
//  StudyBookApp
//
//  Created by t&a on 2024/11/08.
//

import SwiftUI

struct DetailBookView: View {
    @EnvironmentObject private var rootEnvironment: RootEnvironment
    
    // プロパティとして保持するとCPUがオーバーフローする
    //private let df = DateFormatUtility()
    public var book: Book
    @Environment(\.dismiss) private var dismiss
    var body: some View {
        VStack {
            HeaderView(
                leadingIcon: "chevron.backward",
                leadingAction: {
                    dismiss()
                },
                content: {
                    Text(book.title)
                        .lineLimit(1)
                }
            )
            
            ScrollView(showsIndicators: false) {
                
                HStack(alignment: .top) {
                    
                    if let name = rootEnvironment.getCategoryName(book.categoryId) {
                        HStack(spacing: 0) {
                            Circle()
                                .fill(.white)
                                .frame(width: 10, height: 10)
                            
                            Spacer()
                            
                            Text(name)
                                .fontSS(bold: true)
                                .foregroundStyle(.white)
                                .lineLimit(1)
                            
                            Spacer()
                        }.padding(8)
                            .frame(width: 120, height: 30)
                            .background(.themaBlack)
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                    }
                    
                    Spacer()
                    
                    // 本のサムネイル
                    BookThumbnailView(book: book, width: 150, height: 225)
                    
                }.padding()
                
                itemTextView(title: "タイトル", body: book.title)
                
                itemTextView(title: "著者", body: book.concatenationAuthors)
                
                itemTextView(title: "概要", body: book.desc)
                
                itemTextView(title: "登録日時", body: DateFormatUtility().getString(date: book.createdAt))
                
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
