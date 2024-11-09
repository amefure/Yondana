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
    @State private var category: Category = Category()
    
    var body: some View {
        VStack {
            ZStack(alignment: .bottomTrailing) {
                
                if rootEnvironment.categorys.isEmpty {
                    List {
                        ForEach(rootEnvironment.categorys.filter({ $0.id != Category.unSelectCategryID}).sorted(by: { $0.name < $1.name})) { category in
                            Button {
                                self.category = category
                                isPresented = true
                            } label: {
                                VStack(alignment: .leading) {
                                    
                                    HStack {
                                        HStack(spacing: 0) {
                                            Circle()
                                                .fill(.white)
                                                .frame(width: 10, height: 10)
                                            
                                            Spacer()
                                            
                                            Text(category.name)
                                                .fontS(bold: true)
                                                .foregroundStyle(.white)
                                                .lineLimit(1)
                                            
                                            Spacer()
                                        }.padding(8)
                                            .frame(width: 120, height: 30)
                                            .background(.themaBlack)
                                            .clipShape(RoundedRectangle(cornerRadius: 8))
                                        
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
                                                    .fill(.themaBlack)
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
                                }.roundedRectangleShadowBackView(height: height * 1.5)
                            }.listRowSeparator(.hidden)
                        }
                    }.scrollContentBackground(.hidden)
                        .background(.white)
                        .listStyle(.grouped)
                } else {
                    EmptyDataView(text: "カテゴリがありません。")
                }
                   
                
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
                                .foregroundStyle(.white)
                                
                        }.shadow(color: .gray,radius: 3, x: 2, y: 2)
                }.alignmentGuide(.trailing) { _ in 80 }
                    .alignmentGuide(.bottom) { _ in 80 }
            }
        }.sheet(isPresented: $showSearchView) {
            InputCategoryView()
                .environmentObject(rootEnvironment)
        }.navigationDestination(isPresented: $isPresented) {
            DetailCategoryView(category: category)
                .environmentObject(rootEnvironment)
        }
    }
}

#Preview {
    CategoryListView()
        .environmentObject(RootEnvironment())
}
