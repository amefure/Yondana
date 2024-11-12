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
    @State private var isAlert = false
    @State private var showDeleteConfirmAlert = false
    @State private var showEditView: Bool = false
    
    @State private var title: String = ""
    @State private var content: String = ""
    
    @Environment(\.dismiss) private var dismiss
    var body: some View {
        VStack {
            HeaderView(
                leadingIcon: "chevron.backward",
                trailingIcon: "square.and.pencil",
                leadingAction: {
                    dismiss()
                },
                trailingAction: {
                    showEditView = true
                },
                content: {
                    Text(book.title)
                        .lineLimit(1)
                }
            )
            
            ScrollView(showsIndicators: false) {
                
                HStack(alignment: .top) {
                    
                    if let name = rootEnvironment.getCategoryName(book.categoryId) {
                        CategoryLabelView(name: name)
                    }
                    
                    Spacer()
                    
                    // 本のサムネイル
                    BookThumbnailView(book: book, width: 150, height: 225)
                    
                }.padding()
                
                ItemTextView(title: "タイトル", content: book.title, isAlert: $isAlert, msgTitle: $title, msgContent: $content)
                
                ItemTextView(title: "著者", content: book.concatenationAuthors, isAlert: $isAlert,  msgTitle: $title, msgContent: $content)
                
                ItemTextView(title: "概要", content: book.desc, isAlert: $isAlert,  msgTitle: $title, msgContent: $content)
                
                ItemTextView(title: "登録日時", content: DateFormatUtility().getString(date: book.createdAt), isAlert: $isAlert,  msgTitle: $title, msgContent: $content)
                
                ItemTextView(title: "購入金額", content: book.amount == -1 ? "ー" : "\(book.amount)円", isAlert: $isAlert,  msgTitle: $title, msgContent: $content)
                
                ItemTextView(title: "MEMO", content: book.memo, isAlert: $isAlert,  msgTitle: $title, msgContent: $content)
                
                Button {
                    showDeleteConfirmAlert = true
                } label: {
                    Text("削除")
                        .frame(width: 150, height: 30)
                        .font(.system(size: 17, weight: .bold))
                        .padding(8)
                        .background(.themaBlack)
                        .foregroundStyle(.white)
                        .fontWeight(.bold)
                        .cornerRadius(8)
                }
                
            }
            
        }.navigationBarBackButtonHidden()
            .fullScreenCover(isPresented: $showEditView) {
                InputBookView(book: book, isSave: Binding.constant(false))
                    .environmentObject(rootEnvironment)
            }.popup(isPresented: $isAlert, title: title, message: content)
            .alert(
                isPresented: $showDeleteConfirmAlert,
                title: "確認",
                message: "この書籍情報を削除しますか？",
                positiveButtonTitle: "削除",
                negativeButtonTitle: "キャンセル",
                positiveButtonRole: .destructive,
                positiveAction: {
                    rootEnvironment.deleteBook(book)
                    dismiss()
                }
            )
   
    }
    

}

private struct ItemTextView: View {
    public let title: String
    public let content: String
    @Binding var isAlert: Bool
    @Binding var msgTitle: String
    @Binding var msgContent: String
    var body: some View {
        VStack(spacing: 0) {
            Text(title)
                .fontS(bold: true)
                .frame(width: DeviceSizeUtility.deviceWidth - 40, alignment: .leading)
            
            Rectangle()
                .frame(width: DeviceSizeUtility.deviceWidth - 40, height: 2)
                .tint(.exText)
                .opacity(0.5)
                .padding(.vertical, 5)
                
            Text(content)
                .fontM(bold: true)
                .frame(width: DeviceSizeUtility.deviceWidth - 40, alignment: .leading)
                .textSelection(.enabled)
                .lineLimit(3)
        }.foregroundStyle(.exText)
            .padding(.bottom)
            .onTapGesture {
                if content.isEmpty {
                    return
                }
                msgTitle = title
                msgContent = content
                isAlert = true
            }
    }
}



#Preview {
    DetailBookView(book: Book())
        .environmentObject(RootEnvironment())
}
