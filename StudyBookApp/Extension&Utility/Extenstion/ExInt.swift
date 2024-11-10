//
//  ExInt.swift
//  StudyBookApp
//
//  Created by t&a on 2024/11/10.
//

extension Int {
    
    /// 数値を金額`n千円/n万円 形式`に変換する
    public func toCurrency() -> String {
        switch self {
        case 1_000..<10_000:
            // 千円単位
            return "\(self / 1_000)千円"
        case 10_000...:
            // 万円単位
            return "\(self / 10_000)万円"
        default:
            // 1千円未満の場合はそのまま円で返す
            return "\(self)円"
        }
    }
}
