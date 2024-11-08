//
//  Category.swift
//  StudyBookApp
//
//  Created by t&a on 2024/11/04.
//

import SwiftUI
import RealmSwift

class Category: Object, Identifiable {
    /// ID
    @Persisted(primaryKey: true) var id: ObjectId
    /// カテゴリ名
    @Persisted var name: String
    /// メモ
    @Persisted var memo: String
    /// 
    @Persisted var books = RealmSwift.List<Book>()
    
    static var unSelectCategry: Category {
        let category = Category()
        category.id = unSelectCategryID
        category.name = "未選択"
        category.memo = "これは未選択用の非公開カテゴリ"
        return category
    }
    /// 未選択カテゴリID(文字列は適当)
    static let unSelectCategryID: ObjectId = ObjectId("64b4fa18e84f9a1b2f0d1c3f")
}
