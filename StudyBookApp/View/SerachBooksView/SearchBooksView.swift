//
//  SearchBooksView.swift
//  StudyBookApp
//
//  Created by t&a on 2024/11/03.
//

import SwiftUI

struct SearchBooksView: View {
    @ObservedObject private var viewModel = SearchBooksViewModel.shared
    @EnvironmentObject private var rootEnvironment: RootEnvironment

    @State private var keyword: String = ""

    @Environment(\.dismiss) private var dismiss
    
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
                        .background(.white)
                        .listStyle(.grouped)
                }
                
                Spacer()
            }
        }.onAppear { viewModel.onAppear(isSaveBooks: rootEnvironment.books) }
            .onDisappear { viewModel.onDisappear() }
    }
    
    private func searchTextFieldView() -> some View {
        HStack {
            TextField("タイトル/著者/ISBN...で検索", text: $keyword)
                .fontL(bold: true)
                .foregroundStyle(.exText)
                .roundedRectangleShadowBackView(width: DeviceSizeUtility.deviceWidth - 70, height: 50)
                
            Button {
                guard !keyword.isEmpty else { return }
                viewModel.fetchBooks(keyword: keyword)
            } label: {
                Image(systemName: "magnifyingglass")
                    .frame(width: 40, height: 40)
                    .fontWeight(.bold)
                    .foregroundStyle(.white)
                    .background(.themaBlack)
                    .clipShape(RoundedRectangle(cornerRadius: 40))
                    .overlay {
                        RoundedRectangle(cornerRadius: 40)
                            .stroke(style: StrokeStyle(lineWidth: 2))
                            .foregroundColor(.white)
                            
                    }.shadow(color: .gray,radius: 3, x: 2, y: 2)
            }
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
                            .foregroundColor(isClick ? .white : .themaBlack)
                            .frame(width: 50)
                            .background(isClick ? .themaBlack : .clear)
                            .cornerRadius(8)
                            .overlay {
                                if !isClick {
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(.themaBlack, lineWidth: 3)
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
