//
//  InputBookView.swift
//  StudyBookApp
//
//  Created by t&a on 2024/11/05.
//

import SwiftUI
import RealmSwift

struct InputBookView: View {
    @EnvironmentObject private var rootEnvironment: RootEnvironment
    
    public let book: Book
    /// 検索登録かどうか
    public var forAPI: Bool = false
    /// API登録時にBinding
    @Binding var isSave: Bool
    
    /// 各プロパティ用変数
    @State private var title: String = ""
    @State private var authors: String = ""
    @State private var desc: String = ""
    @State private var createdAt: Date = Date()
    @State private var amount: String = ""
    @State private var memo: String = ""
    /// カテゴリインデックス選択
    @State private var selectCategoryIndex: Int = 0
    
    @State private var oldCategoryId: ObjectId?
    
    /// カテゴリ新規登録画面表示
    @State private var showCreateCategoryView: Bool = false
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack(spacing: 0) {
            
            HeaderView(
                leadingIcon: "chevron.backward",
                leadingAction: {
                    dismiss()
                },
                content: {
                    Text("書籍登録")
                }
            )
            
            ScrollView(showsIndicators: false) {
                
                // 本のサムネイル
                BookThumbnailView(book: book, width: 150, height: 225)
                    .padding()
                
                VStack(alignment: .leading) {
                    
                    // MARK: カテゴリ選択
                    Group {
                        HStack {
                            Text("カテゴリ")
                                .fontM(bold: true)
                            
                            Button {
                                showCreateCategoryView = true
                            } label: {
                                Image(systemName: "plus")
                                    .fontM(bold: true)
                                    .frame(width: 20)
                            }
                        }
                        
                        Picker(selection: $selectCategoryIndex) {
                            // 未選択
                            ForEach(0..<rootEnvironment.categorys.count, id: \.self) { index in
                                if let name = rootEnvironment.categorys[safe: index]?.name {
                                    Text(name).tag(index)
                                }
                            }
                        } label: {
                            Text("カテゴリ選択")
                        }.labelsHidden()
                            .fontM(bold: true)
                            .tint(.exText)
                            .roundedRectangleShadowBackView(height: 50)
                    }
                    
                    if !forAPI {
                        // MARK: タイトル
                        InputView(title: "タイトル", placeholder: "", text: $title)
                        // MARK: 著者
                        InputView(title: "著者", placeholder: "", text: $authors)
                        // MARK: 概要
                        InputEditView(title: "概要", text: $desc)
                    }
                    
                    // MARK: 登録日時
                    Text("登録日時")
                        .fontM(bold: true)
                    HStack {
                        Spacer()
                        DatePicker(
                            selection: $createdAt,
                            displayedComponents: [.date],
                            label: { Text("登録日時") }
                        ).labelsHidden()
                            .datePickerStyle(.compact)
                            .colorInvert()
                            .colorMultiply(.exText)
                            .tint(.exText)
                            .if(colorScheme == .dark, apply: { view in
                                view
                                    .colorInvert()
                            })
                            
                        Spacer()
                    }
                    
                    // MARK: 金額
                    InputView(title: "書籍購入金額", placeholder: "2500円", isOnlyNumber: true, text: $amount)
                    
                    // MARK: MEMO
                    InputEditView(title: "MEMO", text: $memo)
                    
                }.padding()
                
                AnimationButton(title: !forAPI ? "更新" : "登録") {
                    guard let categoryId = rootEnvironment.categorys[safe: selectCategoryIndex]?.id else { return }
                    if !forAPI {
                        guard let oldCategoryId else { return }
                        let newBook = Book()
                        
                        // ユーザーが変更できない項目もコピー
                        newBook.id = book.id
                        newBook.ISBN_13 = book.ISBN_13
                        newBook.thumbnailUrl = book.thumbnailUrl
                        newBook.pageCount = book.pageCount
                        newBook.publishedDate = book.publishedDate
                        
                        // ユーザー入力項目を反映
                        newBook.title = title
                        newBook.desc = desc
                        // 著者は入力された値を配列の1番目に入れて完了
                        newBook.authors.append(authors)
                        newBook.amount = amount.toInt()
                        newBook.memo = memo
                        newBook.categoryId = categoryId
                        newBook.createdAt = createdAt
                        rootEnvironment.updateBook(
                            newCategoryId: categoryId,
                            oldCategoryId: oldCategoryId,
                            bookId: book.id,
                            updateBook: newBook
                        )
                    } else {
                        book.amount = amount.toInt()
                        book.memo = memo
                        book.categoryId = categoryId
                        book.createdAt = createdAt
                        rootEnvironment.createBook(book)
                        isSave = true
                    }
                    dismiss()
                }
            }.padding(.bottom)
            
        }.foregroundStyle(.exText)
            .fullScreenCover(isPresented: $showCreateCategoryView) {
                InputCategoryView()
                    .environmentObject(rootEnvironment)
            }.onAppear {
                // APIからの遷移ではないなら初期値をセット
                if !forAPI {
                    title = book.title
                    authors = book.concatenationAuthors
                    if book.amount != -1 {
                        amount = String(book.amount)
                    }
                    createdAt = book.createdAt
                    desc = book.desc
                    memo = book.memo
                    oldCategoryId = book.categoryId
                    selectCategoryIndex = rootEnvironment.categorys.firstIndex(where: { $0.id == book.categoryId }) ?? 0
                }
               
            }
    }
}

private struct InputView: View {
    public let title: String
    public let placeholder: String
    public var isOnlyNumber: Bool = false
    @Binding var text: String
    
    var body: some View {
        Text(title)
            .fontM(bold: true)
          
        TextField(placeholder, text: $text)
            .keyboardType(isOnlyNumber ? .numberPad : .default)
            .fontL(bold: true)
            .padding(10)
            .roundedRectangleShadowBackView(height: 50)
            .padding(.bottom)
    }
}

private struct InputEditView: View {
    public let title: String
    @Binding var text: String
    
    var body: some View {
        Text(title)
            .fontM(bold: true)
        
        TextEditor(text: $text)
            .fontM(bold: true)
            .frame(height: 150)
            .roundedRectangleShadowBackView(height: 150)
            .padding(.bottom)
    }
}

#Preview {
    InputBookView(book: Book(), isSave: Binding.constant(false))
        .environmentObject(RootEnvironment())
}


