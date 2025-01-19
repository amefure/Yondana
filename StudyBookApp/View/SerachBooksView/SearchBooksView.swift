//
//  SearchBooksView.swift
//  StudyBookApp
//
//  Created by t&a on 2024/11/03.
//

import SwiftUI

struct SearchBooksView: View {
    @StateObject private var viewModel = SearchBooksViewModel()
    @EnvironmentObject private var rootEnvironment: RootEnvironment

    @State private var keyword: String = ""
    @State var showSearchView = false

    @Environment(\.dismiss) private var dismiss
    
    private func searchBooks() {
        UIApplication.shared.closeKeyboard()
        guard !keyword.isEmpty else { return }
        viewModel.fetchBooks(keyword: keyword)
    }
    
    var body: some View {
        VStack(spacing: 0) {
            
            HeaderView(
                leadingIcon: "chevron.backward",
                leadingAction: {
                    dismiss()
                },
                content: {
                    Text("書籍検索")
                }
            )
            
            searchTextFieldView()

            if !AppManager.sharedNetworkConnectStatusManager.checkIsOnline() {
                ErrorView(msg: "ネットワークに接続してください。")
            } else {
                if viewModel.isLoading {
                    LoadingView(msg: "検索中...")
                }
                
                if let error = viewModel.error {
                    // エラー画面
                    ErrorView(msg: error.message)
                } else if viewModel.resultCount == 0 {
                    // 書籍情報0件表示
                    EmptyDataView(text: "検索に一致する書籍が見つかりませんでした。")

                } else if let count = viewModel.resultCount {
                    Text("\(count)件HIT")
                        .fontM(bold: true)
                    // 対象書籍情報リスト
                    List(viewModel.books) { book in
                        RowBooksView(book: book)
                    }.scrollContentBackground(.hidden)
                        .background(.exSchemeBg)
                        .listStyle(.grouped)
                }
                
                Spacer()
            }
        }.onAppear { viewModel.onAppear(isSaveBooks: rootEnvironment.books) }
            .onDisappear { viewModel.onDisappear() }
            .fullScreenCover(isPresented: $showSearchView) {
                ScanBarCodeView(keyword: $keyword)
                    .environmentObject(rootEnvironment)
            }.onChange(of: showSearchView) { _, newValue in
                // falseになったとき かつ keywordに値があるなら検索を実行する
                guard !showSearchView && !keyword.isEmpty else { return }
                searchBooks()
            }
    }
    
    private func searchTextFieldView() -> some View {
        HStack {
            TextField("タイトル/著者/ISBN...で検索", text: $keyword)
                .fontS(bold: true)
                .foregroundStyle(.exText)
                .roundedRectangleShadowBackView(width: DeviceSizeUtility.deviceWidth - 120, height: 50)
                
            Button {
                searchBooks()
            } label: {
                Image(systemName: "magnifyingglass")
                    .roundedButtonView()
            }.buttonStyle(.plain)
            
            Button {
                showSearchView = true
            } label: {
                Image(systemName: "barcode.viewfinder")
                    .roundedButtonView()
            }.buttonStyle(.plain)
        }.transition(.scale)
            .padding()
    }
}

#Preview {
    SearchBooksView()
        .environmentObject(RootEnvironment())
}



fileprivate struct RowBooksView: View {
    
    @EnvironmentObject private var rootEnvironment: RootEnvironment

    public var book: Book

    @State var isClick: Bool = false
    @State var showSearchView: Bool = false
    
    var body: some View {
        HStack(spacing: 10) {
            // 本のサムネイル
            BookThumbnailView(book: book, width: 70, height: 105)

            // 本の情報&追加ボタン
            VStack(alignment: .leading, spacing: 0) {
                Text(book.title)
                    .font(.system(size: 12))
                    .fontWeight(.bold)
                    .lineLimit(2)
                    .padding(5)
                    .foregroundStyle(.exText)

                Text(book.concatenationAuthors)
                    .font(.system(size: 10))
                    .fontWeight(.bold)
                    .lineLimit(1)
                    .padding(5)
                    .foregroundStyle(.exText)

                Spacer()

                HStack {
                    Spacer()
                    Button {
                        showSearchView = true
                    } label: {
                        Text(isClick ? "済み" : "追加")
                            .font(.system(size: 14))
                            .fontWeight(.bold)
                            .padding(5)
                            .foregroundColor(isClick ? .white : .exText)
                            .frame(width: 50)
                            .background(isClick ? .themaRed : .clear)
                            .cornerRadius(8)
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                            .overlay {
                                if !isClick {
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(.exText, lineWidth: 2)
                                }
                            }
                    }.buttonStyle(.borderless)
                        .disabled(isClick)
                }
            }
        }.padding(10)
            .fullScreenCover(isPresented: $showSearchView) {
                InputBookView(book: book, forAPI: true, isSave: $isClick)
                    .environmentObject(rootEnvironment)
            }
    }
}
