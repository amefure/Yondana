//
//  AllBookDataView.swift
//  StudyBookApp
//
//  Created by t&a on 2024/11/14.
//

import SwiftUI

struct AllBookDataView: View {
    @EnvironmentObject private var rootEnvironment: RootEnvironment

    // dismissで実装するとCPUがオーバーフローする
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
      
            
        VStack(spacing: 0) {
        
            HeaderView(
                leadingIcon: "chevron.backward",
                leadingAction: {
                    presentationMode.wrappedValue.dismiss()
                },
                content: {
                    Text("ALL BOOKS")
                        .font(.system(size: 20))
                        .lineLimit(1)
                }
            )
            
            
            ScrollView(showsIndicators: false) {
                
                BooksChartsView(books: Array(rootEnvironment.books))
                    .environmentObject(rootEnvironment)
               
                ItemTextView(title: "合計冊数", content: "\(rootEnvironment.books.count)冊", contentAlignment: .center)
                
                ItemTextView(title: "累計金額", content: "\(rootEnvironment.calcSumAmount(books: rootEnvironment.books.filter { $0.amount != -1 }).toAmountString())円", contentAlignment: .center)
                
                ItemTextView(title: "最終登録日", content: rootEnvironment.getLatestDay(books: rootEnvironment.books), contentAlignment: .center)
              
                Spacer()
            }
        
            
        }.foregroundStyle(.exText)
            .navigationBarBackButtonHidden()
        
    }
}


#Preview {
    AllBookDataView()
        .environmentObject(RootEnvironment())
}
