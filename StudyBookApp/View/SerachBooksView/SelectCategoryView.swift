//
//  SelectCategoryView.swift
//  StudyBookApp
//
//  Created by t&a on 2024/11/05.
//

import SwiftUI
import RealmSwift

struct SelectCategoryView: View {
    @EnvironmentObject private var rootEnvironment: RootEnvironment
    public var book: Book
    @State private var amount: String = ""
    @State private var memo: String = ""
    @State private var selectCategoryIndex: Int = 0
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
           
            
            HStack {
                
                Text("カテゴリ")
                    .foregroundStyle(.exText)
                    .font(.system(size: 17, weight: .bold))
                
                Spacer()
                
                Picker(selection: $selectCategoryIndex) {
                    // 未選択
                    ForEach(0..<rootEnvironment.categorys.count, id: \.self) { index in
                        if let name = rootEnvironment.categorys[safe: index]?.name {
                            Text(name).tag(index)
                        }
                    }
                } label: {
                    Text("カテゴリ選択")
                }.labelsHidden()
                    .font(.system(size: 17, weight: .bold))
                    .tint(.themaBlack)
                    .roundedRectangleShadowBackView(height: 50)
            }.padding(20)
             
           
            
            VStack(alignment: .leading) {
                Text("書籍購入金額")
                    .foregroundStyle(.exText)
                    .fontM(bold: true)
                  
                TextField("2500", text: $amount)
                    .keyboardType(.numberPad)
                    .fontL(bold: true)
                    .padding(10)
                    .roundedRectangleShadowBackView(height: 50)
                    .padding(.bottom)

                
                Text("MEMO")
                    .fontM(bold: true)
                    .foregroundStyle(.exText)
                  
                TextEditor(text: $memo)
                    .fontM(bold: true)
                    .frame(height: 150)
                    .roundedRectangleShadowBackView(height: 150)
            }.padding()
        
            
            Button {
                guard let categoryId = rootEnvironment.categorys[safe: selectCategoryIndex]?.id else { return }
                book.amount = amount.toInt()
                book.memo = memo
                book.categoryId = categoryId
                book.createdAt = Date()
                rootEnvironment.createBook(book)
                dismiss()
            } label: {
                Text("登録")
                    .frame(width: 150, height: 30)
                    .font(.system(size: 17, weight: .bold))
                    .padding(8)
                    .background(.themaBlack)
                    .foregroundStyle(.white)
                    .fontWeight(.bold)
                    .cornerRadius(8)
            }
            
            
            Spacer()
            
        }.onAppear {
        }
    }
    
}

#Preview {
    SelectCategoryView(book: Book())
}


