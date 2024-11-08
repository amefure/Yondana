//
//  CategoryListView.swift
//  StudyBookApp
//
//  Created by t&a on 2024/11/05.
//

import SwiftUI

struct CategoryListView: View {
    @EnvironmentObject private var rootEnvironment: RootEnvironment
    @State private var showSearchView = false
    
    var body: some View {
        VStack {
            ZStack(alignment: .bottomTrailing) {
                List {
                    ForEach(rootEnvironment.categorys.filter({ $0.id != Category.unSelectCategryID})) { category in
                        NavigationLink {
                            DetailCategoryView(category: category)
                                .environmentObject(rootEnvironment)
                        } label: {
                            HStack {
                                Image(systemName: "folder")
                                    .fontM(bold: true)
                                Text(category.name)
                                    .fontL(bold: true)
                            }.foregroundStyle(.white)
                        }
                    }.listRowBackground(Color.themaBlack)
                }.scrollContentBackground(.hidden)
                    .background(.white)
                    .listStyle(.grouped)
                
                Button {
                    showSearchView = true
                } label: {
                    Image(systemName: "plus")
                        .frame(width: 40, height: 40)
                        .fontWeight(.bold)
                        .foregroundStyle(.white)
                        .background(.themaBlack)
                        .clipShape(RoundedRectangle(cornerRadius: 40))
                        .overlay {
                            RoundedRectangle(cornerRadius: 40)
                                .stroke(style: StrokeStyle(lineWidth: 2))
                                .foregroundColor(.white)
                                
                        }.shadow(color: .gray, radius: 1, x: 1, y: 1)
                }.alignmentGuide(.trailing) { _ in 80 }
                    .alignmentGuide(.bottom) { _ in 80 }
            }
        }.sheet(isPresented: $showSearchView) {
            InputCategoryView()
                .environmentObject(rootEnvironment)
        }
    }
}

#Preview {
    CategoryListView()
        .environmentObject(RootEnvironment())
}
