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
                        .foregroundStyle(.exText)
                }.frame(width: 30)
                    .padding(.trailing)
                
                if mode {
                    NavigationLink {
                        AllBookDataView()
                            .environmentObject(rootEnvironment)
                    } label: {
                        Image(systemName: "chart.bar")
                            .fontL(bold: true)
                            .foregroundStyle(.exText)
                            .frame(width: 30)
                    }.frame(width: 30)
                }
                
                Spacer()
                
                Text(mode ? "ALL BOOKS" : "CATEGORYS")
                    .fontL(bold: true)
                    .foregroundStyle(.exText)
                
                Spacer()
                
                if mode {
                    Spacer()
                        .frame(width: 30)
                }
          
                NavigationLink {
                    SettingView()
                } label: {
                    Image(systemName: "gearshape")
                        .fontL(bold: true)
                        .foregroundStyle(.exText)
                }.frame(width: 30)
                    .padding(.leading)
            }.padding(.horizontal)
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
