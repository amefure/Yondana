//
//  BooksChartsViewModel.swift
//  StudyBookApp
//
//  Created by t&a on 2024/11/04.
//

import SwiftUI

class BooksChartsViewModel: ObservableObject {
    
    @Published private(set) var booksDateDic: [Date: [Book]] = [:]

    private let dateFormatUtility = DateFormatUtility()
    /// グラフの月の過去に戻している数(マイナス値)
    private var currentChartsMonth: Int = 0
    
    public func onAppear(books: [Book]) {
        dayBookDictionary(books)
    }
    
    /// 前月に移動する
    public func backMonth(books: [Book]) {
        currentChartsMonth -= 1
        dayBookDictionary(books)
    }
    /// 翌月に移動する(最大当月まで)
    public func forwardMonth(books: [Book]) {
        currentChartsMonth += 1
        if currentChartsMonth > 0 {
            currentChartsMonth = 0
        }
        dayBookDictionary(books)
    }
    
    /// Bookを月毎にセクション分けした辞書型に変換する
    public func dayBookDictionary(_ books: [Book]) {
        
        let targetLastDay = dateFormatUtility.dateByAdding(Date(), by: .month, value: currentChartsMonth)
        
        /// 実際のデータが入った辞書型を作成
        var groupedRecords = Dictionary(grouping: books) { [weak self] book in
            guard let self else { return targetLastDay }
            return dateFormatUtility.startOfMonth(book.createdAt)
        }
       
        // 今月のDate型を取得
        let targetLastMonth = dateFormatUtility.startOfMonth(targetLastDay)
        // 6ヶ月前の日付を計算
        let sixMonthsAgo = dateFormatUtility.dateByAdding(targetLastMonth, by: .month, value: -5)
        // 6ヶ月前の日付の月単位の最初の日
        let targetStartMonth = dateFormatUtility.startOfMonth(sixMonthsAgo)
        
        var date = targetStartMonth
        // 現在の月の最初の日付をキーとして辞書に存在しない場合、空の配列で追加
        while date <= targetLastDay {
            if groupedRecords[date] == nil {
                groupedRecords[date] = []
            }
            // 次の月の最初の日付を計算
            let nextMonth = dateFormatUtility.dateByAdding(date, by: .month, value: 1)
            date = dateFormatUtility.startOfMonth(nextMonth)
        }
        // ターゲット月〜6ヶ月後月の間のデータのみにフィルタリング
        groupedRecords = groupedRecords.filter { (key, _) in
            key >= targetStartMonth && key <= targetLastMonth
        }
        booksDateDic = groupedRecords
    }
    
}
