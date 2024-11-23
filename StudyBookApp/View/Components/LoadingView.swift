//
//  LoadingView.swift
//  StudyBookApp
//
//  Created by t&a on 2024/11/10.
//

import SwiftUI
import Combine

struct LoadingView: View {
    
    @StateObject private var viewModel = LoadingViewModel()
    public let msg: String

    var body: some View {
        VStack {
            Spacer()
            
            Text(msg)
                .fontL(bold: true)
                .foregroundStyle(.exText)
                .padding(.bottom)
            
            HStack(spacing: 3) {
                ForEach(0..<6, id: \.self) { index in
                    Image(systemName: "book")
                        .fontL(bold: true)
                        .foregroundStyle(.exText)
                        .offset(y: -viewModel.height)
                        .animation(.easeInOut(duration: 0.4).delay(0.1 * Double(index)), value: viewModel.height)
                }
            }
            
            Spacer()
        }.onAppear { viewModel.onAppear() }
            .onDisappear { viewModel.onDisappear() }
    }
}

#Preview {
    LoadingView(msg: "メッセージ")
}
