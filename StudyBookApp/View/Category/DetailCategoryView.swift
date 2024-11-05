//
//  DetailCategoryView.swift
//  StudyBookApp
//
//  Created by t&a on 2024/11/05.
//

import SwiftUI

struct DetailCategoryView: View {
    @EnvironmentObject private var rootEnvironment: RootEnvironment
    public let category: Category
    var body: some View {
        VStack {
            
            VStack {
                Text(category.name)
                    .font(.system(size: 20))
                    
                Text(category.memo)
                    .font(.system(size: 14))
            }.roundedRectangleShadowBackView(height: 80)
            
            
            Text("\(rootEnvironment.books.count)冊")
                .roundedRectangleShadowBackView(height: 80)
            
            Text("\(rootEnvironment.books.count)冊")
                .roundedRectangleShadowBackView(height: 80)
            
            BookGridListView()
                .environmentObject(rootEnvironment)
            
        }.foregroundStyle(.exText)
            .onAppear { rootEnvironment.filteringAllBooks(categoryId: category.id.stringValue) }
            .onDisappear { rootEnvironment.readAllBooks() }
    }
}

#Preview {
    DetailCategoryView(category: Category())
        .environmentObject(RootEnvironment())
}
