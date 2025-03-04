//
//  ScanBarCodeViewModel.swift
//  StudyBookApp
//
//  Created by t&a on 2024/11/21.
//


import SwiftUI
import Combine
import AVFoundation

class ScanBarCodeViewModel: ObservableObject {
    
    @Published var showRequestAllowed: Bool = false
    @Published private(set) var ISBNcode: String = ""
    @Published private(set) var previewLayer: CALayer?
    
    private var cancellables: Set<AnyCancellable> = Set()
    
    private var cameraRepository: CameraFunctionRepository
    
    init(repositoryDependency: RepositoryDependency = RepositoryDependency()) {
        cameraRepository = repositoryDependency.cameraFunctionRepository
    }
    
    @MainActor
    public func onAppear() {
        cameraRepository.ISBNcode.sink { [weak self] image in
            guard let self else { return }
            self.ISBNcode = image
        }.store(in: &cancellables)
        
        cameraRepository.previewLayer.sink { [weak self] previewLayer in
            guard let self else { return }
            self.previewLayer = previewLayer
        }.store(in: &cancellables)
        
        // 権限が許可されているならカメラをセット
        allowedRequestStatus { [weak self] result in
            guard let self else { return }
            if result {
                self.cameraRepository.prepareSetting()
                self.startSession()
            } else {
                self.showRequestAllowed = true
            }
        }
        
    }
    
    public func onDisappear() {
        ISBNcode = ""
        previewLayer = nil
        endSession()
        
        if cancellables.count != 0 {
            cancellables.forEach { $0.cancel() }
            cancellables.removeAll()
        }
    }
}

// MARK: - カメラ機能
extension ScanBarCodeViewModel {
    /// セッション開始
    public func startSession() {
        cameraRepository.startSession()
    }
    /// セッション終了
    public func endSession() {
        cameraRepository.endSession()
    }
    
    /// カメラ利用の承認申請アラート表示メソッド
    private func allowedRequestStatus(completion: @escaping (Bool) -> Void) {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            completion(true)
            break
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video, completionHandler: { granted in
                completion(granted)
            })
        default:
            completion(false)
            break
        }
    }
    
    ///
    public func showSettingApp() {
        guard let settingsURL = URL(string: UIApplication.openSettingsURLString) else { return }
        DispatchQueue.main.async {
            if UIApplication.shared.canOpenURL(settingsURL) {
                UIApplication.shared.open(settingsURL)
            }
        }
        
    }
}
