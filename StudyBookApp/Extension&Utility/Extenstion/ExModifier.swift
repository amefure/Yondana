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
                      .stroke(style: StrokeStyle(lineWidth: 2))
                }
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .clipped()
                .shadow(color: .gray,radius: 3, x: 2, y: 2)
    }
}

/// 角丸 + 枠線 + 影
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
    
    /// 文字サイズ M
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

