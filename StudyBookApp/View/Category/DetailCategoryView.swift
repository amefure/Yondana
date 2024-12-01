//
//  DetailCategoryView.swift
//  StudyBookApp
//
//  Created by t&a on 2024/11/05.
//

import SwiftUI
import Charts

struct DetailCategoryView: View {
    @EnvironmentObject private var rootEnvironment: RootEnvironment
   
    @State private var showDesc: Bool = false
    @State private var showEditView: Bool = false
    @State private var showDeleteConfirmAlert: Bool = false

    // dismissで実装するとCPUがオーバーフローする
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        if let category = rootEnvironment.currentCategory {
            VStack(spacing: 0) {
            
                HeaderView(
                    leadingIcon: "chevron.backward",
                    trailingIcon: "square.and.pencil",
                    leadingAction: {
                        presentationMode.wrappedValue.dismiss()
                    },
                    trailingAction: {
                        showEditView = true
                    },
                    content: {
                        Text(category.name)
                            .font(.system(size: 20))
                            .lineLimit(1)
                    }
                )
                
          
                HStack(alignment: .top) {
                    Text(category.memo)
                        .frame(width: DeviceSizeUtility.deviceWidth - 80, alignment: .leading)
                        .font(.system(size: 17))
                        .foregroundStyle(.white)
                        .lineLimit(showDesc ? .none : 1)
                    
                    Button {
                        withAnimation {
                            showDesc.toggle()
                        }
                    } label: {
                        Image(systemName: showDesc ? "chevron.up" : "chevron.down")
                            .fontWeight(.bold)
                            .foregroundStyle(.white)
                    }
                }.frame(width: DeviceSizeUtility.deviceWidth)
                    .padding([.horizontal, .bottom])
                    .background(.themaBlack)
                
                ScrollView(showsIndicators: false) {
                    
                    BooksChartsView(books: Array(category.books))
                        .environmentObject(rootEnvironment)
                   
                    
                    NavigationLink {
                        BookGridListView(category: category)
                            .environmentObject(rootEnvironment)
                    } label: {
                        HStack {
                            Spacer()
                            Text("書籍一覧：\(category.books.count)冊")
                                .font(.system(size: 17))
                            
                            Image(systemName: "chevron.forward")
                                .font(.system(size: 14))
                                .fontWeight(.bold)
                        }.foregroundStyle(.exText)
                    }.padding()

                    
                    VStack {
                        if category.books.isEmpty {
                            HStack {
                                Spacer()
                                Text("書籍情報がありません")
                                Spacer()
                            }
                        } else {
                            ScrollView(.horizontal, showsIndicators: false) {
                                LazyHStack(spacing: 15) {
                                    ForEach(category.books) { book in
                                        NavigationLink {
                                            DetailBookView(book: book)
                                                .environmentObject(rootEnvironment)
                                        } label: {
                                            if let image = AppManager.sharedImageFileManager.fetchImage(name: book.id) {
                                                image
                                                    .resizable()
                                                    .shadow(color: .gray, radius: 3, x: 4, y: 4)
                                                    .frame(width: DeviceSizeUtility.deviceWidth / 4 - 20, height: DeviceSizeUtility.isSESize ? 100 : 120)
                                            } else {
                                                Text(book.title)
                                                    .fontWeight(.bold)
                                                    .font(.caption)
                                                    .foregroundColor(.gray)
                                                    .padding(5)
                                                    .frame(width: DeviceSizeUtility.deviceWidth / 4 - 20, height: DeviceSizeUtility.isSESize ? 100 : 120)
                                                    .frame(minWidth: DeviceSizeUtility.deviceWidth / 4 - 20)
                                                    .frame(maxHeight: DeviceSizeUtility.isSESize ? 100 : 120)
                                                    .background(.white)
                                                    .clipped()
                                                    .shadow(color: .gray, radius: 3, x: 4, y: 4)
                                            }
                                        }.buttonStyle(.plain)
                                    }
                                }
                            }
                        }
                    }.frame(height: DeviceSizeUtility.isSESize ? 120 : 140)
                        .padding(.horizontal)
                        .padding(.vertical)
                        
                    VStack(alignment: .leading) {
                        Text("累計金額")
                            .fontM()
                        Text("\(rootEnvironment.calcSumAmount(books: Array(category.books.filter { $0.amount != -1 })))円")
                            .fontL(bold: true)
                            .roundedRectangleShadowBackView(height: 80, background: .exSchemeBg)
                    }
                
                
                    Button {
                        showDeleteConfirmAlert = true
                    } label: {
                        Text("削除")
                            .roundedRectangleButtonView()
                    }.padding(.top)
                   
                    Spacer()
                }
            
                
            }.foregroundStyle(.exText)
                .navigationBarBackButtonHidden()
                .fullScreenCover(isPresented: $showEditView) {
                    InputCategoryView(category: category)
                        .environmentObject(rootEnvironment)
                }.alert(
                    isPresented: $showDeleteConfirmAlert,
                    title: "確認",
                    message: "このカテゴリを削除しますか？",
                    positiveButtonTitle: "削除",
                    negativeButtonTitle: "キャンセル",
                    positiveButtonRole: .destructive,
                    positiveAction: {
                        rootEnvironment.deleteCategory(category)
                        presentationMode.wrappedValue.dismiss()
                    }
                )
        }
    }
}

#Preview {
    DetailCategoryView()
        .environmentObject(RootEnvironment())
}
