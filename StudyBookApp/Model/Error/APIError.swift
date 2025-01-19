//
//  APIError.swift
//  StudyBookApp
//
//  Created by t&a on 2024/11/09.
//

enum APIError: Error {
    /// EA001：ネットワーク接続エラー
    case networkConnection

    /// EA002：Google Books APIのレスポンスエラー
    case response
    
    /// EA003：無効なURLエラー
    case invalidURL

    /// EA004：不明なエラー
    case unidentified
    

    

    public var title: String { "APIエラー" }

    public var message: String {
        return switch self {
        case .networkConnection:
            "ネットワークに接続してください。"
        case .response:
            "通信エラーが発生しました。何度も繰り返される場合はアプリを起動し直して再度実行してみてください。"
        case .invalidURL:
            "通信エラーが発生しました。何度も繰り返される場合はアプリを起動し直して再度実行してみてください。"
        case .unidentified:
            "予期せぬエラーが発生しました。何度も繰り返される場合はアプリを起動し直して再度実行してみてください。"
        }
    }
}
