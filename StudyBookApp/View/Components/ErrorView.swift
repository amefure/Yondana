//
//  ErrorView.swift
//  StudyBookApp
//
//  Created by t&a on 2024/11/09.
//

import SwiftUI

struct ErrorView: View {
    public var msg: String
    var body: some View {
        VStack(spacing: 40) {
            Spacer()
            
            Text("ERROR")
                .fontL(bold: true)
                .foregroundStyle(.themaRed)
            
            Image(systemName: "multiply.circle.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 80)
                .foregroundStyle(.themaRed)
            
            Text(msg)
                .fontL(bold: true)
                .foregroundStyle(.exText)
            
            Spacer()
        }.frame(width: DeviceSizeUtility.deviceWidth)
    }
}

#Preview {
    ErrorView(msg: "ERROR")
}
