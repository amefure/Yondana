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
    public let book: Book
    @Binding var isSave: Bool
    
    @State private var amount: String = ""
    @State private var memo: String = ""
    @State private var selectCategoryIndex: Int = 0
    @State private var showEditView: Bool = false
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
                .padding()
    
            VStack(alignment: .leading) {
                
                HStack {
                    Text("カテゴリ")
                        .fontM(bold: true)
                    
                    Button {
                        showEditView = true
                    } label: {
                        Image(systemName: "plus")
                            .fontM(bold: true)
                            .frame(width: 20)
                    }
                }
               
                
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
                    .fontM(bold: true)
                    .tint(.exText)
                    .roundedRectangleShadowBackView(height: 50)
                
                Text("書籍購入金額")
                    .fontM(bold: true)
                  
                TextField("2500円", text: $amount)
                    .keyboardType(.numberPad)
                    .fontL(bold: true)
                    .padding(10)
                    .roundedRectangleShadowBackView(height: 50)
                    .padding(.bottom)

                
                Text("MEMO")
                    .fontM(bold: true)
                  
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
                isSave = true
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
                    .shadow(color: .gray,radius: 3, x: 2, y: 2)
            }
            
            
            Spacer()
            
        }.foregroundStyle(.exText)
            .fullScreenCover(isPresented: $showEditView) {
                InputCategoryView()
                    .environmentObject(rootEnvironment)
            }
    }
    
}

#Preview {
    SelectCategoryView(book: Book(), isSave: Binding.constant(false))
}


