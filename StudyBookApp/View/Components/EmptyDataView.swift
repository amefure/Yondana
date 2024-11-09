//
//  EmptyDataView.swift
//  StudyBookApp
//
//  Created by t&a on 2024/11/09.
//

import SwiftUI

struct EmptyDataView: View {
    public var text: String = "登録されている書籍情報がありません。"
    var body: some View {
        VStack {
            Spacer()
            
            Asset.Images.bookImage1.swiftUIImage
                .resizable()
                .scaledToFit()
                .frame(width: 300)
            
            Text(text)
                .fontL(bold: true)
                .foregroundStyle(.exText)
            
            Spacer()
        }.frame(width: DeviceSizeUtility.deviceWidth)
    }
}

#Preview {
    EmptyDataView()
}
