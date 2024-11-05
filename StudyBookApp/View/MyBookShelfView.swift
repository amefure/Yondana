//
//  MyBookShelfView.swift
//  StudyBookApp
//
//  Created by t&a on 2024/11/04.
//

import SwiftUI

struct MyBookShelfView: View {
    @EnvironmentObject private var rootEnvironment: RootEnvironment
     
    @State private var showSearchView: Bool = false
    var body: some View {
        VStack {
            ZStack(alignment: .bottomTrailing) {
                
                BookGridListView()
                    .environmentObject(rootEnvironment)
                
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
        }.fullScreenCover(isPresented: $showSearchView) {
            SearchBooksView()
                .environmentObject(rootEnvironment)
        }
    }
}

#Preview {
    MyBookShelfView()
        .environmentObject(RootEnvironment())
}
