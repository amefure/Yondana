//
//  SelectCategoryView.swift
//  StudyBookApp
//
//  Created by t&a on 2024/11/05.
//

import SwiftUI

struct SelectCategoryView: View {
    @EnvironmentObject private var rootEnvironment: RootEnvironment
    public var book: Book
    @State private var amount: String = "0"
    @State private var memo: String = ""
    @State private var selectCategory: Category = Category()
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack(spacing: 0) {
            
            HeaderView(
                leadingIcon: "chevron.backward",
                leadingAction: {
                    dismiss()
                },
                content: {
                    Text("書籍登録")
                }
            )
            
            // 本のサムネイル
            BookThumbnailView(book: book, width: 150, height: 225)
            
            Spacer()
           
            
            Picker(selection: $selectCategory) {
                ForEach(rootEnvironment.categorys) { category in
                    Text(category.name).tag(category as Category)
                }
            } label: {
                Text("カテゴリ選択")
            }
            
            TextField("", text: $amount)
                .keyboardType(.numberPad)
                .textFieldStyle(.roundedBorder)
            
            TextEditor(text: $memo)
        
            
            Button {
                book.amount = amount.toInt()
                book.memo = memo
                book.categoryId = selectCategory.id.stringValue
                book.createdAt = Date()
                rootEnvironment.createBook(book)
                dismiss()
            } label: {
                Text("登録")
                    .frame(width: 200, height: 80)
                    .font(.system(size: 20, weight: .bold))
                    .padding(10)
                    .background(.themaBlack)
                    .foregroundStyle(.white)
                    .cornerRadius(8)
            }
            
            
            Spacer()
            
        }
    }
    
}

#Preview {
    SelectCategoryView(book: Book())
}


