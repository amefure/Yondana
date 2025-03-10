//
//  BookGridListView.swift
//  StudyBookApp
//
//  Created by t&a on 2024/11/05.
//

import SwiftUI

struct BookGridListView: View {
    @EnvironmentObject private var rootEnvironment: RootEnvironment
    public var category: Category? = nil
    private let columns = Array(repeating: GridItem(.fixed(DeviceSizeUtility.deviceWidth / 4 - 15)), count: 4)
    
    private var books: [Book] {
        return category == nil ? rootEnvironment.books : Array(category!.books)
    }
  
    // dismissで実装するとCPUがオーバーフローする
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack {
            if let category = category {
                HeaderView(
                    leadingIcon: "chevron.backward",
                    leadingAction: {
                        presentationMode.wrappedValue.dismiss()
                    },
                    content: {
                        Text(category.name)
                            .font(.system(size: 20))
                            .lineLimit(1)
                    }
                )
            }
            
            if !books.isEmpty {
                ScrollView {
                    LazyVGrid(columns: columns) {
                        ForEach(books) { book in
                            NavigationLink {
                                DetailBookView(book: book)
                                    .environmentObject(rootEnvironment)
                            } label: {
                                if let image = AppManager.sharedImageFileManager.fetchImage(name: book.id) {
                                    image
                                        .resizable()
                                        .shadow(color: .gray, radius: 3, x: 4, y: 4)
                                        .frame(height: DeviceSizeUtility.isSESize ? 100 : 120)
                                } else {
                                    Text(book.title)
                                        .fontWeight(.bold)
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                        .padding(5)
                                        .frame(minWidth: DeviceSizeUtility.deviceWidth / 4 - 15)
                                        .frame(height: DeviceSizeUtility.isSESize ? 100 : 120)
                                        .frame(maxHeight: DeviceSizeUtility.isSESize ? 100 : 120)
                                        .background(.white)
                                        .clipped()
                                        .shadow(color: .gray, radius: 3, x: 4, y: 4)
                                }
                            }.buttonStyle(.plain)
                        }
                    }
                }
            } else {
                EmptyDataView()
            }
            
        }.navigationBarBackButtonHidden()
    }
}

#Preview {
    BookGridListView()
        .environmentObject(RootEnvironment())
}
