//
//  UserDefaultsRepository.swift
//  StudyBookApp
//
//  Created by t&a on 2024/11/02.
//

import UIKit

class UserDefaultsKey {

}

/// `UserDefaults`の基底クラス
/// マルチスレッドからの参照を考慮するためactor定義
/// 全てのメソッドが`acync`になる
actor UserDefaultsRepository {

    /// `UserDefaults`が`Sendable`ではない
    private let userDefaults: UserDefaults = UserDefaults.standard

    /// Bool：保存
    public func setBoolData(key: String, isOn: Bool) {
        userDefaults.set(isOn, forKey: key)
    }

    /// Bool：取得
    public func getBoolData(key: String) -> Bool {
        return userDefaults.bool(forKey: key)
    }

    /// Int：保存
    public func setIntData(key: String, value: Int) {
        userDefaults.set(value, forKey: key)
    }

    /// Int：取得
    public func getIntData(key: String) -> Int {
        return userDefaults.integer(forKey: key)
    }

    /// String：保存
    public func setStringData(key: String, value: String) {
        userDefaults.set(value, forKey: key)
    }

    /// String：取得
    public func getStringData(key: String, initialValue: String = "") -> String {
        return userDefaults.string(forKey: key) ?? initialValue
    }
}
