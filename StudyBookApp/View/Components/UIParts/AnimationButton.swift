//
//  AnimationButton.swift
//  StudyBookApp
//
//  Created by t&a on 2024/12/01.
//
import SwiftUI

struct AnimationButton: View {
    
    public let title: String
    public let action: () -> Void
    
    @State private var percent: CGFloat = 0.0
    @State private var drawProgress: CGFloat = 0.0
    
    var body: some View {
        VStack {
            Button {
                withAnimation(.easeInOut(duration: 1.0)) {
                    percent = 1.0
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                        drawProgress = 1.0
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.4) {
                        action()
                    }
                }
            } label: {
                HStack {
                    AnimatedCheckMarkView(drawProgress: $drawProgress)
                    
                    Spacer()
                       
                    
                    Text(title)
                        .fontM(bold: true)
                    
                    Spacer()
                    
                    Spacer()
                        .frame(width: 30)
                }.padding()
                
            }.background(
                ZStack(alignment: .leading) {
                    Color.clear
                        .frame(width: 200)
                    Color.themaRed
                        .frame(width: 200 * percent)
                }
            ).roundedRectangleButtonView()
                
                
        }
        .padding()
    }
}
