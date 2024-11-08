//
//  Book.swift
//  StudyBookApp
//
//  Created by t&a on 2024/11/03.
//

import UIKit
import RealmSwift

class Book: Object, Identifiable {
    /// 書籍ID
    @Persisted(primaryKey: true) var id: String
    /// タイトル
    @Persisted var title: String
    /// 著書の配列
    @Persisted var authors = RealmSwift.List<String>()
    /// 説明
    @Persisted var desc: String
    /// ISBN
    @Persisted var ISBN_13: String
    /// ページ数
    @Persisted var pageCount: Int
    /// 発行日
    @Persisted var publishedDate: String
    /// サムネイルURL(http)
    @Persisted var thumbnailUrl: String

    // MARK: - ↑　APIから取得する情報

    // MARK: - ↓　個人で蓄積できる情報
    /// 金額
    @Persisted var amount: Int
    /// 本自体のメモ
    @Persisted var memo: String
    /// 並び順
    @Persisted var createdAt: Date
    /// 並び順
    @Persisted var categoryId: ObjectId

    /// サムネイルURLをセキュアなURLに変換
    public var secureThumbnailUrl: URL? {
        guard !thumbnailUrl.isEmpty else { return nil }
        let replaceUrlStr = thumbnailUrl.replacingOccurrences(of: "http://", with: "https://")
        guard let url = URL(string: replaceUrlStr) else { return nil }
        return url
    }

    /// 著者情報「 / 」でを繋げた文字列
    public var concatenationAuthors: String {
        guard let firstAuthors = authors[safe: 0] else { return "" }
        var connect = ""
        for author in authors {
            if firstAuthors == author {
                connect += author
            } else {
                connect += "/" + author
            }
        }
        return connect
    }
    
    static func demoBook() -> Book {
        let book = Book()
        book.title = "Swift UIを触ってみよう"
        book.amount = 2000
        book.memo = "ここにテキストここにテキストここにテキスト\nここにテキストここにテキスト"
        return book

    }
    
    
}
