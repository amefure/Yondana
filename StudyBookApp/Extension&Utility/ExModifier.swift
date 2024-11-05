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


extension View {
    /// 角丸 + 枠線 + 影
    func roundedRectangleShadowBackView(width: CGFloat = DeviceSizeUtility.deviceWidth - 40, height: CGFloat) -> some View {
        modifier(RoundedRectangleShadowBackView(width: width, height: height))
    }
    
}

