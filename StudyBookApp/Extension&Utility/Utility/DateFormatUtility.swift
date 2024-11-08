//
//  DateFormatUtility.swift
//  MinnanoTanjyoubi
//
//  Created by t&a on 2023/02/12.
//

import UIKit

class DateFormatUtility {
    
    private let df = DateFormatter()
    private var c = Calendar(identifier: .gregorian)
    
    init(format: String = "yyyy年M月d日") {
        df.dateFormat = format
        df.locale = Locale(identifier: L10n.dateLocale)
        if Locale.current.identifier.hasPrefix(Locale(identifier: L10n.dateLocale).identifier) {
            c.timeZone = TimeZone(identifier: L10n.dateTimezone)!
        }
        df.calendar = c
    }
}
    
// MARK: -　DateFormatter
extension DateFormatUtility {
    
    /// `Date`型を受け取り`String`型を返す
    public func getString(date: Date) -> String {
        return df.string(from: date)
    }
    
    /// `String`型を受け取り`Date`型を返す
    public func getDate(str: String) -> Date {
        return df.date(from: str) ?? Date()
    }
}

// MARK: -　Calendar
extension DateFormatUtility {
    
    /// `Date`型を受け取り`DateComponents`型を返す
    /// - Parameters:
    ///   - date: 変換対象の`Date`型
    ///   - components: `DateComponents`で取得したい`Calendar.Component`
    /// - Returns: `DateComponents`
    public func convertDateComponents(date: Date, components: Set<Calendar.Component> = [.year, .month, .day, .hour, .minute, .second]) -> DateComponents {
        c.dateComponents(components, from: date)
    }
    
    /// `DateComponents`型を受け取り`Date`型を返す
    public func convertComponentsDate(datDateComponentse: DateComponents) -> Date {
        c.date(from: datDateComponentse) ?? Date()
    }
    
    /// `Date`型を受け取りその日の00:00:00の`Date`型を返す
    public func startOfDay(_ date: Date) -> Date {
        return c.startOfDay(for: date)
    }
    
    /// `Date`型を受け取りその日の属する月の最初の`Date`型を返す
    public func startOfMonth(_ date: Date) -> Date {
        let components = c.dateComponents([.year, .month], from: date)
        let startOfMonth = c.date(from: components) ?? Date()
        return startOfMonth
    }
    
    /// Date型の加算/減算
    /// - Parameters:
    ///   - date: 対象の日付
    ///   - by: 対象コンポーネント
    ///   - value: 値
    /// - Returns: 結果
    public func dateByAdding(_ date: Date, by: Calendar.Component, value: Int) -> Date {
        return c.date(byAdding: by, value: value, to: date) ?? Date()
    }
    
    /// Date型の加算/減算
    public func dateByAdding(_ date: Date, byAdding: DateComponents) -> Date {
        return c.date(byAdding: byAdding, to: date) ?? Date()
    }
    
    /// 受け取った日付が指定した日と同じかどうか
    public func checkInSameDayAs(date: Date, sameDay: Date = Date()) -> Bool {
        // 時間をリセットしておく
        let resetDate = c.startOfDay(for: date)
        let resetToDay = c.startOfDay(for: sameDay)
        return c.isDate(resetDate, inSameDayAs: resetToDay)
    }
    
    /// 指定した日付の年月をタプルで取得
    public func getDateYearAndMonth(date: Date = Date()) -> (year: Int, month: Int) {
        let today = convertDateComponents(date: date)
        guard let year = today.year,
              let month = today.month else { return (2024, 8) }
        return (year, month)
    }
    
    public func inMonth(date: Date, year: Int, month: Int) -> Bool {
        let components = c.dateComponents([.year, .month], from: date)
        return components.year == year && components.month == month
    }
}
