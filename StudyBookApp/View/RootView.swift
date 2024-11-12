//
//  RootView.swift
//  StudyBookApp
//
//  Created by t&a on 2024/11/02.
//

import SwiftUI

struct RootView: View {
    @ObservedObject private var rootEnvironment = RootEnvironment.shared

    /// 書籍 or カテゴリモード切り替え
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
                    SettingView()
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
           
            AdMobBannerView()
                .frame(height: 60)
        }.onAppear { rootEnvironment.onAppear() }
            .onDisappear { rootEnvironment.onDisappear() }
    }
}

#Preview {
    RootView()
}
