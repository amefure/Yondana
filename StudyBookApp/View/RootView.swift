//
//  RootView.swift
//  StudyBookApp
//
//  Created by t&a on 2024/11/02.
//

import SwiftUI

struct RootView: View {
    @ObservedObject private var rootEnvironment = RootEnvironment()

    @State private var mode: Bool = false
    var body: some View {
        VStack {
            
            Button {
                mode.toggle()
            } label: {
                Text("MODE")
            }
            
//            TabViewLayout(selectTab: $selectTab) {
//                
//                switch selectTab {
//                case 0:
//                    CategoryListView()
//                        .environmentObject(rootEnvironment)
//                case 1:
//                    MyBookShelfView()
//                        .environmentObject(rootEnvironment)
//                default:
//                    MyBookShelfView()
//                        .environmentObject(rootEnvironment)
//                }
//            }
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
