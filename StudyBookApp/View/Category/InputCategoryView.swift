//
//  InputCategoryView.swift
//  StudyBookApp
//
//  Created by t&a on 2024/11/04.
//

import SwiftUI

struct InputCategoryView: View {
    @EnvironmentObject private var rootEnvironment: RootEnvironment
    
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
                    Text("設定")
                }
            )
            
            VStack {
                Text("カテゴリ名")
                TextField("", text: $name)
                    .font(.system(size: 20, weight: .bold))
                    .padding(10)
                    .background(.themaBlack)
                    .foregroundStyle(.white)
                    .cornerRadius(8)
                
                Text("MEMO")
                TextEditor(text: $memo)
                    .font(.system(size: 20, weight: .bold))
                    .padding(10)
                    .background(.themaBlack)
                    .foregroundStyle(.white)
                    .cornerRadius(8)
                
                Button {
                    guard !name.isEmpty && !memo.isEmpty else { return }
                    rootEnvironment.createCategory(name: name, memo: memo)
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
                
            }.padding()
           
            Spacer()
        }
    }
}

#Preview {
    InputCategoryView()
        .environmentObject(RootEnvironment())
}
