//
//  CategoryLabelView.swift
//  StudyBookApp
//
//  Created by t&a on 2024/11/11.
//

import SwiftUI

struct CategoryLabelView: View {
    public let name: String
    var body: some View {
        HStack(spacing: 0) {
            Circle()
                .fill(.white)
                .frame(width: 10, height: 10)
            
            Spacer()
            
            Text(name)
                .fontS(bold: true)
                .foregroundStyle(.white)
                .lineLimit(1)
            
            Spacer()
        }.padding(8)
            .frame(width: 120, height: 30)
            .background(.themaBlack)
            .clipShape(RoundedRectangle(cornerRadius: 8))
    }
}

#Preview {
    CategoryLabelView(name: "")
}
