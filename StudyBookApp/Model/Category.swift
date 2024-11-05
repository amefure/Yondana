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
}
