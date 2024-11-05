//
//  ImageFileManager.swift
//  StudyBookApp
//
//  Created by t&a on 2024/11/03.
//

import UIKit
import SwiftUI
import Combine

/// アプリからデバイス内(Documentsフォルダ)へ画像を保存するクラス
class ImageFileManager {
    
    private var fileManager = FileManager.default
    private var suffix = ".jpg"
    
    /// Documentsフォルダまでのパスを取得
    private func fetchDocumentsUrl(_ fileName: String) -> URL? {
        do {
            
            let docsUrl = try fileManager.url(
                for: .documentDirectory,
                in: .userDomainMask,
                appropriateFor: nil,
                create: false
            )
            // URLを構築
            let url = docsUrl.appendingPathComponent(fileName)
            return url
        } catch {
            return nil
        }
    }
    
    /// 画像取得
    public func fetchImage(name: String) -> Image? {
        guard !name.isEmpty else { return nil }
        guard let path = fetchDocumentsUrl("\(name + suffix)")?.path else { return nil }
        guard fileManager.fileExists(atPath: path) else { return nil }
        guard let image = UIImage(contentsOfFile: path) else { return nil }
        return Image(uiImage: image)
    }
    
    /// 画像パス取得
    public func fetchImagePath(name: String) -> String? {
        guard !name.isEmpty else { return nil }
        guard let path = fetchDocumentsUrl("\(name + suffix)")?.path else { return nil }
        guard fileManager.fileExists(atPath: path) else { return nil }
        guard let image = UIImage(contentsOfFile: path) else { return nil }
        return path
    }

    /// 画像保存処理
    ///  let name = urlStr.replacingOccurrences(of: "/", with: "!") // 変換
    public func saveImage(name: String, image: UIImage) -> AnyPublisher<Void, ImageError> {
        Deferred {
            Future<Void, ImageError>() { [weak self] promise in
                guard let self = self else { return promise(.failure(.castFailed)) }
                guard let imageData = image.jpegData(compressionQuality: 1.0) else { return promise(.failure(.castFailed)) }
                guard let path = self.fetchDocumentsUrl("\(name + self.suffix)") else { return promise(.failure(.castFailed)) }
                do {
                    try imageData.write(to: path)
                    promise(.success(()))
                } catch {
                    promise(.failure(.saveFailed))
                }
            }
        }.eraseToAnyPublisher()
    }
    
    /// URLで指定した画像を保存する
    public func savingImage(name: String, urlStr: String) -> AnyPublisher<Void, ImageError> {
        Deferred {
            Future<Void, ImageError>() { [weak self] promise in
                guard let self = self else { return promise(.failure(.castFailed)) }
                // URLの文字列をUIImage型に変換
                guard let url = URL(string: urlStr) else { return promise(.failure(.castFailed)) }
                do {
                    let data = try Data(contentsOf: url)
                    guard let image = UIImage(data: data) else { return promise(.failure(.castFailed)) }
                    guard let imageData = image.jpegData(compressionQuality: 1.0) else { return promise(.failure(.castFailed)) }
                    guard let path = self.fetchDocumentsUrl("\(name + self.suffix)") else { return promise(.failure(.castFailed)) }
                    try imageData.write(to: path)
                    promise(.success(()))
                } catch {
                    promise(.failure(.saveFailed))
                }
            }
        }.eraseToAnyPublisher()

    }
    
    /// 画像削除処理
    public func deleteImage(name: String) -> AnyPublisher<Void, ImageError> {
        Deferred {
            Future<Void, ImageError>() { [weak self] promise in
                guard let self = self else { return promise(.failure(.castFailed)) }

                guard let path = self.fetchDocumentsUrl("\(name + self.suffix)") else { return promise(.failure(.castFailed)) }
                do {
                    try fileManager.removeItem(at: path)
                    promise(.success(()))
                } catch {
                    promise(.failure(.deleteFailed))
                }
            }
        }.eraseToAnyPublisher()
    }
}
