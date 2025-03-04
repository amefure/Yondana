//
//  LoadingViewModel.swift
//  StudyBookApp
//
//  Created by t&a on 2024/11/10.
//
import Combine
import SwiftUI

// MARK: 順番上下ローディング
@MainActor
final class LoadingViewModel: ObservableObject {

    @Published private(set) var height: Double = 0
    @Published private(set) var timerPublisher: AnyCancellable?
    
    public func onAppear() {
        startLoading()
    }
    
    public func onDisappear() {
        stopLoading()
    }
    
    private func startLoading() {
        timerPublisher = Timer.publish(every: 0.3, on: .main, in: .common)
            .autoconnect()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                guard let self else { return }
                self.height += 15
                if self.height == 30 {
                    self.height = 0
                    self.timerPublisher?.cancel()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
                        guard let self else { return }
                        self.startLoading()
                    }
                }
            }
    }
    
    private func stopLoading() {
        height = 0
        timerPublisher?.cancel()
    }
    
}

// MARK: 回転ローディング
//@State private var degrees: Double = 0
//@State private var timerPublisher: AnyCancellable?
//ZStack(alignment: .top) {
//    
//    Image(systemName: "book")
//        .rotationEffect(Angle(degrees: -degrees))
//        .offset(x: 0, y: -30)
//        
//    
//    Image(systemName: "book")
//        .rotationEffect(Angle(degrees: -degrees))
//        .offset(x: -30, y: 0)
//    
//    Image(systemName: "book")
//        .rotationEffect(Angle(degrees: -degrees))
//        .offset(x: 30, y: 0)
//    
//    Image(systemName: "book")
//        .rotationEffect(Angle(degrees: -degrees))
//        .offset(y: 30)
//}.frame(width: 60, height: 60)
//    .rotationEffect(Angle(degrees: degrees))
//    .onAppear {
//        timerPublisher = Timer.publish(every: 0.1, on: .current, in: .common)
//            .autoconnect()
//            .sink { _ in
//                withAnimation {
//                    self.degrees += 15
//                }
//            }
//    }
