//
//  BookThumbnailView.swift
//  StudyBookApp
//
//  Created by t&a on 2024/11/05.
//

import SwiftUI

struct BookThumbnailView: View {
    public let book: Book
    public let width: CGFloat
    public let height: CGFloat
    var body: some View {
        // 本のサムネイル
        if let url = book.secureThumbnailUrl {
            AsyncImage(url: url) { image in
                image.resizable()
            } placeholder: {
                ProgressView()
            }.frame(width: width, height: height)
                .shadow(color: .gray, radius: 3, x: 4, y: 4)
        } else {
            Image("No_Image")
                .resizable()
                .frame(width: width, height: height)
                .shadow(color: .gray, radius: 3, x: 4, y: 4)
        }
    }
}

#Preview {
    BookThumbnailView(book: Book(), width: 100, height: 200)
}
