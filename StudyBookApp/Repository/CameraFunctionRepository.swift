//
//  CameraFunctionRepository.swift
//  StudyBookApp
//
//  Created by t&a on 2024/11/21.
//

import SwiftUI
import AVFoundation
import Combine

/// カメラ機能を提供するリポジトリ
/// バーコードをスキャンする
class CameraFunctionRepository: NSObject, AVCapturePhotoCaptureDelegate, AVCaptureMetadataOutputObjectsDelegate {
    
    /// 読み取ったISBNコード
    public var ISBNcode: AnyPublisher<String, Never> {
        _ISBNcode.eraseToAnyPublisher()
    }
    
    private let _ISBNcode = PassthroughSubject<String, Never>()
    
    /// カメラプレビュー領域
    public var previewLayer: AnyPublisher<CALayer, Never> {
        _previewLayer.eraseToAnyPublisher()
    }
    
    private let _previewLayer = PassthroughSubject<CALayer, Never>()
    
    /// 撮影デバイス
    private var capturepDevice: AVCaptureDevice!
    
    private var avSession: AVCaptureSession = AVCaptureSession()
    private var avInput: AVCaptureDeviceInput!
}

extension CameraFunctionRepository {
    
    ///  初期準備
    public func prepareSetting() {
        setUpDevice()
        beginSession()
    }
    
    /// セッション開始
    public func startSession() {
        DispatchQueue.global(qos: .background).async { [weak self] in
            guard let self else { return }
            if self.avSession.isRunning { return }
            self.avSession.startRunning()
        }
    }
    
    /// セッション終了
    public func endSession() {
        if !avSession.isRunning { return }
        avSession.stopRunning()
    }
}

extension CameraFunctionRepository {
    
    // 使用するデバイスを取得
    private func setUpDevice() {
        avSession.sessionPreset = .photo
        
        guard let device = AVCaptureDevice.default(for: .video) else { return }
        capturepDevice = device
    }
    
    // セッションの開始
    private func beginSession() {
        self.avSession = AVCaptureSession()
        guard let videoDevice = AVCaptureDevice.default(for: .video) else { return }
        
        do {
            let deviceInput = try AVCaptureDeviceInput(device: videoDevice)
            
            if self.avSession.canAddInput(deviceInput) {
                self.avSession.addInput(deviceInput)
                self.avInput = deviceInput
                
                // バーコード読取用Outputの指定
               let metadataOutput = AVCaptureMetadataOutput()
                if self.avSession.canAddOutput(metadataOutput) {
                    self.avSession.addOutput(metadataOutput)
                    
                    metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
                    // バーコードの種類を指定 EAN13 == ISBN対応
                    metadataOutput.metadataObjectTypes = [.ean13]
                    
                    // 読取エリアの設定
                    let x: CGFloat = 0.1
                    let y: CGFloat = 0.4
                    let width: CGFloat = 0.8
                    let height: CGFloat = 0.2
                    metadataOutput.rectOfInterest = CGRect(x: y, y: 1 - x - width, width: height, height: width)
                    
                    // 読取エリアを可視化
                    let readingArea = CALayer()
                    readingArea.frame = CGRect(
                        x: DeviceSizeUtility.deviceWidth * x,
                        y: DeviceSizeUtility.deviceHeight * y,
                        width: DeviceSizeUtility.deviceWidth * width,
                        height: DeviceSizeUtility.deviceHeight * height
                    )
                    readingArea.borderWidth = 1
                    readingArea.cornerRadius = 5
                    readingArea.borderColor = UIColor.white.cgColor
                    
                    let previewLayer = AVCaptureVideoPreviewLayer(session: self.avSession)
                    previewLayer.videoGravity = .resize
                    previewLayer.addSublayer(readingArea)
                    self._previewLayer.send(previewLayer)
                    
                    self.avSession.sessionPreset = AVCaptureSession.Preset.photo
                }
            }
        } catch {
            // エラー
        }
    }
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        for metadata in metadataObjects as! [AVMetadataMachineReadableCodeObject] {
            guard let code = metadata.stringValue  else { return }
            DispatchQueue.main.async { [weak self] in
                self?._ISBNcode.send(code)
            }
        }
    }
}

// カメラプレビュー
struct CALayerView: UIViewRepresentable {
    var caLayer: CALayer
    
    func makeUIView(context: Context) -> UIView {
        let baseView = UIView()
        // プレビューの大きさを指定 iPhoneのカメラは4:3なのでそれに合わせる
        /// `previewLayer.videoGravity = .resize` を指定することでレイヤーいっぱいに合わせる
        caLayer.frame = CGRect(x: 0, y: 0, width: DeviceSizeUtility.deviceWidth, height: DeviceSizeUtility.deviceWidth)
        baseView.layer.addSublayer(caLayer)

        return baseView
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        // プレビューの大きさを指定 iPhoneのカメラは4:3なのでそれに合わせる
        /// `previewLayer.videoGravity = .resize` を指定することでレイヤーいっぱいに合わせる
        caLayer.frame = CGRect(x: 0, y: 0, width: DeviceSizeUtility.deviceWidth, height: DeviceSizeUtility.deviceHeight)
    }
}
