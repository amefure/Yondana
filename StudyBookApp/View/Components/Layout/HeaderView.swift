//
//  HeaderView.swift
//  StudyBookApp
//
//  Created by t&a on 2024/11/04.
//

import SwiftUI

struct HeaderView<Content: View>: View {
    
    let leadingIcon: String
    let trailingIcon: String
    let leadingAction: () -> Void
    let trailingAction: () -> Void
    let content: Content
    
    
    init(leadingIcon: String = "",
         trailingIcon: String = "",
         leadingAction: @escaping () -> Void = {},
         trailingAction: @escaping () -> Void = {},
         @ViewBuilder content: @escaping () -> Content) {
        self.leadingIcon = leadingIcon
        self.trailingIcon = trailingIcon
        self.leadingAction = leadingAction
        self.trailingAction = trailingAction
        self.content = content()
    }
    
    var body: some View {
        HStack {
            
            if !leadingIcon.isEmpty {
                Button {
                    leadingAction()
                } label: {
                    Image(systemName: leadingIcon)
                        .font(.system(size: 18))
                        .padding(.leading, 5)
                        .frame(width: 50)
                }.frame(width: 50)
            } else if !trailingIcon.isEmpty {
                Spacer()
                    .frame(width: 50)
            }
            
            Spacer()
            
            content
            
            Spacer()
            
            if !trailingIcon.isEmpty {
                Button {
                    trailingAction()
                } label: {
                    Image(systemName: trailingIcon)
                        .font(.system(size: 18))
                        .padding(.trailing, 5)
                        .frame(width: 50)
                }.frame(width: 50)
                
            } else if !leadingIcon.isEmpty {
                Spacer()
                    .frame(width: 50)
            }
        }.padding(.vertical)
            .foregroundStyle(.white)
            .fontWeight(.bold)
            .background(.themaBlack)
    }
}

#Preview {
    HeaderView(
        leadingIcon: "swift",
        trailingIcon: "iphone",
        leadingAction: {},
        trailingAction: {},
        content: {}
    )
}

