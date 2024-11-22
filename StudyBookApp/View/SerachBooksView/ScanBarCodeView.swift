//
//  ScanBarCodeView.swift
//  StudyBookApp
//
//  Created by t&a on 2024/11/21.
//

import SwiftUI

struct ScanBarCodeView: View {
    @ObservedObject private var viewModel = ScanBarCodeViewModel()
    @Binding var keyword: String
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack {
            ZStack(alignment: .top) {
                HStack {
                    
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "chevron.backward")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 15, height: 15)
                            .padding(8)
                            .fontWeight(.bold)
                            .foregroundStyle(.themaBlack)
                            .background(.white)
                            .clipShape(RoundedRectangle(cornerRadius: 20))
                    }
                
                    Spacer()
                }.padding(.horizontal)
                    .padding(.top)
                    .zIndex(2)
                
                if let previewLayer = viewModel.previewLayer {
                    CALayerView(caLayer: previewLayer)
                        .onAppear {
                            viewModel.startSession()
                        }.onDisappear {
                            viewModel.endSession()
                        }.zIndex(1)
                } else {
                    EmptyDataView(text: "カメラの権限を許可してください。")
                        .zIndex(1)
                }
            }
           
        }.onAppear { viewModel.onAppear() }
            .onChange(of: viewModel.ISBNcode) { _, newValue in
                guard !newValue.isEmpty else { return }
                keyword = newValue
                dismiss()
            }.alert(
                isPresented: $viewModel.showRequestAllowed,
                title: "確認",
                message: "設定アプリからカメラの権限を許可してください。",
                positiveButtonTitle: "設定を開く",
                negativeButtonTitle: "キャンセル",
                positiveButtonRole: nil,
                positiveAction: {
                    viewModel.showSettingApp()
                }
            )
    }
}

