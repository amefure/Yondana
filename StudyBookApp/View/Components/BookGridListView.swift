//
//  BookGridListView.swift
//  StudyBookApp
//
//  Created by t&a on 2024/11/05.
//

import SwiftUI

struct BookGridListView: View {
    @EnvironmentObject private var rootEnvironment: RootEnvironment
    private let columns = Array(repeating: GridItem(.fixed(DeviceSizeUtility.deviceWidth / 4 - 20)), count: 4)
  
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns) {
                ForEach(rootEnvironment.books) { book in
                    NavigationLink {
                        //DetailBookView(book: book)
                        Text(book.title)
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
                                .frame(minWidth: DeviceSizeUtility.deviceWidth / 4 - 20)
                                .frame(height: DeviceSizeUtility.isSESize ? 100 : 120)
                                .frame(maxHeight: DeviceSizeUtility.isSESize ? 100 : 120)
                                .background(.white)
                                .clipped()
                                .shadow(color: .gray, radius: 3, x: 4, y: 4)
                        }
                    }
                }
            }
            Spacer()
        }
    }
}

#Preview {
    BookGridListView()
        .environmentObject(RootEnvironment())
}
