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
    
    private let width = DeviceSizeUtility.deviceWidth / 6
    private let height = (DeviceSizeUtility.deviceWidth / 6) * 1.5
    @State private var isPresented: Bool = false
    
    var body: some View {
        VStack {
            ZStack(alignment: .bottomTrailing) {
                
                if !rootEnvironment.categorys.filter({ $0.id != Category.unSelectCategryID}).isEmpty {
                    List {
                        ForEach(rootEnvironment.categorys.filter({ $0.id != Category.unSelectCategryID}).sorted(by: { $0.name < $1.name})) { category in
                            Button {
                                rootEnvironment.currentCategory = category
                                isPresented = true
                            } label: {
                                VStack(alignment: .leading) {
                                    
                                    HStack {
                                        CategoryLabelView(name: category.name)
                                        
                                        Spacer()
                                        
                                        Text("\(category.books.count)冊")
                                            .fontM(bold: true)
                                            .foregroundStyle(.exText)
                                    }
                                  
                                    if category.books.count != 0 {
                                        HStack {
                                            Spacer()
                                            
                                            ZStack {
                                                
                                                if let book1 = category.books[safe: 0] {
                                                    BookThumbnailView(book: book1, width: width, height: height)
                                                        .zIndex(3)
                                                }
                                                
                                                if let book2 = category.books[safe: 1] {
                                                    BookThumbnailView(book: book2, width: width, height: height)
                                                        .zIndex(2)
                                                        .offset(x: 40)
                                                }
                                                
                                                if let book3 = category.books[safe: 2] {
                                                    BookThumbnailView(book: book3, width: width, height: height)
                                                        .zIndex(1)
                                                        .offset(x: 80)
                                                }
                                            }
                                            
                                            Spacer()
                                                .frame(width: 100)
                                            
                                            ForEach(0..<3, id: \.self) { _ in
                                                Circle()
                                                    .fill(.exText)
                                                    .frame(width: 4, height: 4)
                                            }
                                            
                                        }
                                    } else {
                                        Spacer()
                                        
                                        Text("登録されている書籍がありません。")
                                            .fontM(bold: true)
                                            .foregroundStyle(.exText)
                                        
                                        Spacer()
                                    }
                                }.roundedRectangleShadowBackView(height: height * 1.5, background: .exSchemeBg)
                            }.listRowSeparator(.hidden)
                        }
                    }.scrollContentBackground(.hidden)
                        .background(.exSchemeBg)
                        .listStyle(.grouped)
                } else {
                    EmptyDataView(text: "カテゴリがありません。")
                }
                   
                
                Button {
                    showSearchView = true
                } label: {
                    Image(systemName: "plus")
                        .roundedButtonView()
                }.alignmentGuide(.trailing) { _ in 80 }
                    .alignmentGuide(.bottom) { _ in DeviceSizeUtility.isSESize ? 40 : 60 }
            }
        }.sheet(isPresented: $showSearchView) {
            InputCategoryView()
                .environmentObject(rootEnvironment)
        }.navigationDestination(isPresented: $isPresented) {
            DetailCategoryView()
                .environmentObject(rootEnvironment)
        }
    }
}

#Preview {
    CategoryListView()
        .environmentObject(RootEnvironment())
}
