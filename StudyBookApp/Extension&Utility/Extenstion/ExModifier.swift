//
//  ExModifier.swift
//  PrankMemo
//
//  Created by t&a on 2024/08/27.
//

import SwiftUI

/// 角丸 + 枠線 + 影
struct RoundedRectangleShadowBackView: ViewModifier {

    public var width: CGFloat
    public var height: CGFloat
    func body(content: Content) -> some View {
        content
            .padding()
                .frame(width: width, height: height)
                .background(.white)
                .overlay {
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(.themaBlack, style: StrokeStyle(lineWidth: 2))
                }
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .clipped()
                .shadow(color: .gray, radius: 3, x: 2, y: 2)
    }
}

/// 角丸 + 枠線ボタン
struct RoundedRectangleButtonView: ViewModifier {

    func body(content: Content) -> some View {
        content
            .frame(width: 150, height: 30)
            .fontM(bold: true)
            .padding(8)
            .background(.themaBlack)
            .foregroundStyle(.white)
            .cornerRadius(8)
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
    func roundedRectangleShadowBackView(width: CGFloat = DeviceSizeUtility.deviceWidth - 40, height: CGFloat) -> some View {
        modifier(RoundedRectangleShadowBackView(width: width, height: height))
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

