//
//  ItemTextView.swift
//  StudyBookApp
//
//  Created by t&a on 2024/11/14.
//

import SwiftUI

struct ItemTextView: View {
    public let title: String
    public let content: String
    public var contentAlignment: Alignment = .leading
    var body: some View {
        VStack(spacing: 0) {
            Text(title)
                .fontS(bold: true)
                .frame(width: DeviceSizeUtility.deviceWidth - 40, alignment: .leading)
            
            Rectangle()
                .frame(width: DeviceSizeUtility.deviceWidth - 40, height: 2)
                .tint(.exText)
                .opacity(0.5)
                .padding(.vertical, 10)
                
            Text(content)
                .fontM(bold: true)
                .frame(width: DeviceSizeUtility.deviceWidth - 40, alignment: contentAlignment)
                .textSelection(.enabled)
                .lineLimit(3)
        }.foregroundStyle(.exText)
            .padding(.bottom)
    }
}

#Preview {
    ItemTextView(title: "タイトル", content: "コンテンツ")
}
