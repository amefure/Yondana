//
//  RootView.swift
//  StudyBookApp
//
//  Created by t&a on 2024/11/02.
//

import SwiftUI

struct RootView: View {
    @ObservedObject private var rootEnvironment = RootEnvironment.shared

    @State private var mode: Bool = true
    var body: some View {
        VStack {
            
            HStack {
                
                Button {
                    mode.toggle()
                } label: {
                    Image(systemName: mode ? "folder" : "rectangle.grid.3x2")
                        .fontL(bold: true)
                        .foregroundStyle(.themaBlack)
                }
                
                Spacer()
                
                Text(mode ? "ALL BOOKS" : "CATEGORYS")
                    .fontL(bold: true)
                    .foregroundStyle(.themaBlack)
                Spacer()
          
                NavigationLink {
                    
                } label: {
                    Image(systemName: "gearshape")
                        .fontL(bold: true)
                        .foregroundStyle(.themaBlack)
                }
            }.padding(.horizontal, 30)
                .padding(.vertical, 10)
            if mode  {
                MyBookShelfView()
                    .environmentObject(rootEnvironment)
            } else {
                CategoryListView()
                    .environmentObject(rootEnvironment)
            }
           
        }.onAppear { rootEnvironment.onAppear() }
            .onDisappear { rootEnvironment.onDisappear() }
        
    }
}

#Preview {
    RootView()
}
