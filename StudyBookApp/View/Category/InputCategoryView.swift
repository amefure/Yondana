//
//  InputCategoryView.swift
//  StudyBookApp
//
//  Created by t&a on 2024/11/04.
//

import SwiftUI

struct InputCategoryView: View {
    @EnvironmentObject private var rootEnvironment: RootEnvironment
    public var category: Category? = nil
    @State private var name = ""
    @State private var memo = ""
    @Environment(\.dismiss) private var dismiss
    var body: some View {
        VStack {
            
            HeaderView(
                leadingIcon: "chevron.backward",
                leadingAction: {
                    dismiss()
                },
                content: {
                    Text(category == nil ? "カテゴリ登録": "カテゴリ編集")
                }
            )
            
            VStack(alignment: .leading) {
                Text("カテゴリ名")
                    .fontWeight(.bold)
                TextField("", text: $name)
                    .font(.system(size: 20, weight: .bold))
                    .padding(10)
                    .roundedRectangleShadowBackView(height: 50)
                    .padding(.bottom)
                
                
                Text("MEMO")
                    .fontWeight(.bold)
                TextEditor(text: $memo)
                    .font(.system(size: 17, weight: .bold))
                    .frame(height: 150)
                    .roundedRectangleShadowBackView(height: 150)
            }.padding()
           
            Button {
                guard !name.isEmpty else { return }
                if let category = category {
                    rootEnvironment.updateCategory(categoryId: category.id, name: name, memo: memo)
                } else {
                    rootEnvironment.createCategory(name: name, memo: memo)
                }
                
                dismiss()
            } label: {
                Text(category == nil ? "登録": "更新")
                    .frame(width: 150, height: 30)
                    .font(.system(size: 17, weight: .bold))
                    .padding(8)
                    .background(.themaBlack)
                    .foregroundStyle(.white)
                    .fontWeight(.bold)
                    .cornerRadius(8)
            }
            
            Spacer()
           
        }.foregroundStyle(.exText)
            .onAppear {
                guard let category = category else { return }
                name = category.name
                memo = category.memo
            }
    }
}

#Preview {
    InputCategoryView()
        .environmentObject(RootEnvironment())
}
