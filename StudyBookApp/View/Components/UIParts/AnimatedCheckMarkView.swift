//
//  AnimatedCheckMarkView.swift
//  StudyBookApp
//
//  Created by t&a on 2024/12/01.
//

import SwiftUI

struct AnimatedCheckMarkView: View {
    @Binding var drawProgress: CGFloat
    public var size: CGFloat = 30
    public var lineWidth: CGFloat = 4

    var body: some View {
        CheckMarkShape()
            .trim(from: 0, to: drawProgress)
            .stroke(Color.themaYellow, lineWidth: lineWidth)
            .frame(width: size, height: size)
            .animation(.easeIn(duration: 0.4), value: drawProgress)
    }
}

struct CheckMarkShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        let startPoint = CGPoint(x: rect.width * 0.2, y: rect.height * 0.5)
        let midPoint = CGPoint(x: rect.width * 0.4, y: rect.height * 0.7)
        let endPoint = CGPoint(x: rect.width * 0.8, y: rect.height * 0.3)

        path.move(to: startPoint)
        path.addLine(to: midPoint)
        path.addLine(to: endPoint)

        return path
    }
}

