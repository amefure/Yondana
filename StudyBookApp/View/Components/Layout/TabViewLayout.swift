//
//  TabViewLayout.swift
//  StudyBookApp
//
//  Created by t&a on 2024/11/04.
//

import SwiftUI

struct TabViewLayout<Content: View>: View {
    
    @EnvironmentObject private var rootEnvironment: RootEnvironment
    
    var content: Content
    
    @Binding private var selectTab: Int
    
    init(selectTab: Binding<Int>, @ViewBuilder content: () -> Content) {
        self._selectTab = selectTab
        self.content = content()
    }
    var body: some View {
        VStack(spacing: 0) {
            Spacer()
            
            content
            
            Spacer()
            
            HStack {
                Spacer()
                
                Button {
                    selectTab = 0
                } label: {
                    Image(systemName: "books.vertical")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 25, height: 25)
                }.foregroundStyle( .white)
                
                Spacer()
                
                Button {
                    selectTab = 1
                } label: {
                    Image(systemName: "house.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 25, height: 25)
                }.foregroundStyle(.white)
                
                Spacer()
                
                Button {
                    selectTab = 2
                } label: {
                    Image(systemName: "chart.bar")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 25, height: 25)
                }.foregroundStyle(.white)
                
                Spacer()
            }.frame(width: DeviceSizeUtility.deviceWidth - 40, height: 60)
                .background(.themaBlack)
                .clipShape(RoundedRectangle(cornerRadius: 20, style: /*@START_MENU_TOKEN@*/.continuous/*@END_MENU_TOKEN@*/))
                .padding(.bottom, 5)
        }
    }
}

#Preview {
    TabViewLayout(selectTab: Binding.constant(0)) {
        Text("Test")
    }
}

