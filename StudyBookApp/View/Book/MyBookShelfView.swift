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
                        .roundedButtonView()
                }.alignmentGuide(.trailing) { _ in 80 }
                    .alignmentGuide(.bottom) { _ in 40 }
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
