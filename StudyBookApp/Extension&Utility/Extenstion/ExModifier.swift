//
//  ExModifier.swift
//  PrankMemo
//
//  Created by t&a on 2024/08/27.
//

import SwiftUI

/// 角丸 + 枠線 + 影
struct RoundedRectangleShadowBackView: ViewModifier {

    public let width: CGFloat
    public let height: CGFloat
    public let background: Color
    func body(content: Content) -> some View {
        content
            .padding()
                .frame(width: width, height: height)
                .background(background)
                .overlay {
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(.exText, style: StrokeStyle(lineWidth: 2))
                }
                .scrollContentBackground(.hidden) // TextEditor用
                .background(background) // TextEditor用
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .clipped()
                .shadow(color: .gray, radius: 3, x: 2, y: 2)
    }
}

/// 角丸 + 枠線ボタン
struct RoundedRectangleButtonView: ViewModifier {

    func body(content: Content) -> some View {
        content
            .padding(8)
            .frame(width: 200, height: 50)
            .fontM(bold: true)
            .background(.themaButton)
            .foregroundStyle(.exWhite)
            .clipShape(RoundedRectangle(cornerRadius: 8))
            .shadow(color: .gray,radius: 3, x: 2, y: 2)
    }
}


/// 角丸 + 枠線 + 影ボタン
struct RoundedButtonView: ViewModifier {

    func body(content: Content) -> some View {
        content
            .frame(width: 40, height: 40)
            .fontWeight(.bold)
            .foregroundStyle(.white)
            .background(.themaBlack)
            .clipShape(RoundedRectangle(cornerRadius: 40))
            .overlay {
                RoundedRectangle(cornerRadius: 40)
                    .stroke(style: StrokeStyle(lineWidth: 2))
                    .foregroundColor(.white)
                    
            }.shadow(color: .gray,radius: 3, x: 2, y: 2)
    }
}

/// フォントサイズ
struct FontSize: ViewModifier {
    public let size: CGFloat
    public let bold: Bool
    func body(content: Content) -> some View {
        content
            .font(.system(size: size))
            .fontWeight(bold ? .bold : .medium)
    }
}


extension View {
    /// 角丸 + 枠線 + 影
    func roundedRectangleShadowBackView(
        width: CGFloat = DeviceSizeUtility.deviceWidth - 40,
        height: CGFloat,
        background: Color = .exWhite
    ) -> some View {
        modifier(RoundedRectangleShadowBackView(width: width, height: height, background: background))
    }
    
    /// 角丸 + 枠線ボタン
    func roundedRectangleButtonView() -> some View {
        modifier(RoundedRectangleButtonView())
    }
    
    /// 角丸 + 枠線 + 影ボタン
    func roundedButtonView() -> some View {
        modifier(RoundedButtonView())
    }
    
    /// 文字サイズ SSS
    func fontSSS(bold: Bool = false) -> some View {
        modifier(FontSize(size: 10, bold: bold))
    }
    
    /// 文字サイズ SS
    func fontSS(bold: Bool = false) -> some View {
        modifier(FontSize(size: 12, bold: bold))
    }
    
    /// 文字サイズ S
    func fontS(bold: Bool = false) -> some View {
        modifier(FontSize(size: 14, bold: bold))
    }
    
    /// 文字サイズ M
    func fontM(bold: Bool = false) -> some View {
        modifier(FontSize(size: 17, bold: bold))
    }
    
    /// 文字サイズ M
    func fontL(bold: Bool = false) -> some View {
        modifier(FontSize(size: 20, bold: bold))
    }

    
}

