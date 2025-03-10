//
//  BooksChartsView.swift
//  StudyBookApp
//
//  Created by t&a on 2024/11/10.
//

import SwiftUI
import Charts

struct BooksChartsView: View {
    @EnvironmentObject private var rootEnvironment: RootEnvironment
    
    @StateObject private var viewModel = BooksChartsViewModel()
    private let df = DateFormatUtility(format: "M月")
    private let dfYear = DateFormatUtility(format: "YYYY年M月")
    public let books: [Book]
    @State private var selectCharts: Int = 0
    
    init(books: [Book]) {
        self.books = books
        self.setUpSegmentedPicker()
    }
    
    private func setUpSegmentedPicker() {
        let appearance = UISegmentedControl.appearance()
        // 選択しているアイテムの背景色ex_text
        appearance.selectedSegmentTintColor = .exText
        let font = UIFont.boldSystemFont(ofSize: 17)
        // 未選択アイテムの文字属性
        appearance.setTitleTextAttributes([.font: font, .foregroundColor: UIColor.exText], for: .normal)
        // 選択アイテムの文字属性
        appearance.setTitleTextAttributes([.font: font, .foregroundColor: UIColor.exWhite], for: .selected)
    }
    
    
    var body: some View {
        VStack {
            Picker(selection: $selectCharts, label: Text("グラフ")) {
                Text("冊数").tag(0)
                Text("金額").tag(1)
            }.pickerStyle(SegmentedPickerStyle())
                .frame(width: DeviceSizeUtility.deviceWidth / 2)
                .tint(.white)
            
            HStack {
                
                Button {
                    viewModel.backMonth(books: books)
                } label: {
                    Image(systemName: "chevron.backward")
                }
                
                let dates = Array(viewModel.booksDateDic.keys)
                if let minDate = dates.min(),
                   let maxDate = dates.max() {
                    Text(dfYear.getString(date: minDate) + "〜" + dfYear.getString(date: maxDate))
                }
                
                Button {
                    viewModel.forwardMonth(books: books)
                } label: {
                    Image(systemName: "chevron.forward")
                }
            }
            
            /// https://qiita.com/yamakentoc/items/55a7d7264691b2caf592#%E3%83%A9%E3%83%99%E3%83%AB
            Chart {
                ForEach(viewModel.booksDateDic.keys.sorted(by: { $0 < $1 }), id: \.self) { date in
                    
                    if let books = viewModel.booksDateDic[date] {
                        BarMark(
                            x: .value("年月", date),
                            y: .value("冊数", selectCharts == 0 ? books.count : rootEnvironment.calcSumAmount(books: books.filter { $0.amount != -1 }))
                        ).foregroundStyle(.themaRed)
                            .annotation {
                                if selectCharts == 0 {
                                    if books.count != 0 {
                                        Text("\(books.count)冊")
                                            .fontS(bold: true)
                                            .foregroundStyle(.exText)
                                            .frame(width: 50)
                                        // No color named 'ex_text' found in asset catalog for
                                        // 上記でカラーを指定するとエラーになるがUI上は問題ない
                                    }
                                } else {
                                    let sum = rootEnvironment.calcSumAmount(books: books)
                                    if sum > 0 {
                                        Text("\(sum)円")
                                            .fontSSS(bold: true)
                                            .foregroundStyle(.exText)
                                            .frame(width: 50)
                                    }
                                }
                            }
                    }
                 
                }
            }.frame(width: DeviceSizeUtility.deviceWidth - 80, height: 200)
                .chartXAxis {
                    // aligned → グラフ線にラベルを合わせる
                    // values: .automatic(desiredCount:) → ラベルの数を明示的に指定
                    AxisMarks(preset: .aligned, values: .automatic(desiredCount: 6)) { axisValue in
                        AxisTick()     // 目盛り線
                        AxisValueLabel {
                            if let date = axisValue.as(Date.self) {
                                // M月形式で表示
                                Text(df.getString(date: date))
                                    .fontS(bold: true)
                                    .foregroundStyle(.exText)
                            }
                        }
                    }
                }.chartYAxis {
                    // Y軸ラベルカスタマイズ
                    AxisMarks { axisValue in
                        AxisGridLine() // グリッド線
                        AxisTick()     // 目盛り線
                        // ラベル値
                        AxisValueLabel {
                            if let amount = axisValue.as(Int.self) {
                                // 冊数 → そのまま
                                // 金額 → 通貨単位で表示
                                Text(selectCharts == 0 ? "\(amount)冊" : "\(amount.toCurrency())")
                                    .lineLimit(1)
                                    .fontSSS(bold: true)
                                    .frame(width: 40, alignment: .trailing)
                            }
                        }
                    }
                }
        }.padding(.vertical)
            .onAppear { viewModel.onAppear(books: books)}

    }
}

#Preview {
    BooksChartsView(books: [])
        .environmentObject(RootEnvironment())
}
