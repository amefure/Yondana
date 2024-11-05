//
//  RelamRepository.swift
//  StudyBookApp
//
//  Created by t&a on 2024/11/03.
//

import RealmSwift
import UIKit

class RealmRepository {
    
    init() {
        let config = Realm.Configuration(schemaVersion: RealmConfig.MIGRATION_VERSION)
        Realm.Configuration.defaultConfiguration = config
        realm = try! Realm()
    }

    private let realm: Realm
    
    
    /// Create
    public func createObject<T: Object>(_ obj: T) {
        try? realm.write {
            realm.add(obj)
        }
    }
    
    /// Read
    public func readAllObjs<T: Object>() -> Array<T> {
        let objs = realm.objects(T.self)
        // Deleteでクラッシュするため凍結させる
        let freezeObjs = objs.freeze().sorted(byKeyPath: "id", ascending: true)
        return Array(freezeObjs)
    }
    
    /// Remove
    public func removeObjs<T: Object & Identifiable>(list: [T]) {
        let ids = list.map(\.id)
        let predicate = NSPredicate(format: "id IN %@", ids)
        let objectsToDelete = realm.objects(T.self).filter(predicate)

        try? realm.write {
            realm.delete(objectsToDelete)
        }
    }
}
