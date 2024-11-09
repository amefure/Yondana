//
//  SearchBooksViewModel.swift
//  StudyBookApp
//
//  Created by t&a on 2024/11/03.
//

import UIKit
import Combine

class SearchBooksViewModel: ObservableObject {
    
    static let shared = SearchBooksViewModel()
    
    public let googleBooksAPIRepository: GoogleBooksAPIRepository
    
    private var cancellables = Set<AnyCancellable>()
    
    /// API検索結果の書籍情報を保持する配列
    /// ローカルに保存済みのものは対象外になる
    @Published private(set) var books: [Book] = []
    @Published private(set) var resultCount: Int = 0
    @Published private(set) var error: APIError? = nil
    @Published private(set) var isLoading: Bool = false
    
    /// ローカルに保存済みの書籍ID
    private var isSaveIds: [String] = []
    
    init(repositoryDependency: RepositoryDependency = RepositoryDependency()) {
        googleBooksAPIRepository = repositoryDependency.googleBooksAPIRepository
    }
    
    public func fetchBooks(keyword: String) {
        books = []
        resultCount = 0
        error = nil
        startLoading()
        googleBooksAPIRepository.fetchBooks(keyword: keyword)
    }
    
    
    private func startLoading() {
        isLoading = true
    }
    
    private func stopLoading() {
        isLoading = false
    }

    public func onAppear(isSaveBooks: [Book]) {
        isSaveIds = isSaveBooks.map(\.id)
        
        googleBooksAPIRepository.books
            .sink(receiveValue: { [weak self] books in
                guard let self else { return }
                /// ローカルに既に保存しているものがあれば除去する
                self.books = books.filter { !self.isSaveIds.contains($0.id) }
                self.stopLoading()
             }).store(in: &cancellables)
        
        googleBooksAPIRepository.resultCount
            .sink(receiveValue: { [weak self] count in
                guard let self else { return }
                self.resultCount = count
                self.stopLoading()
            }).store(in: &cancellables)
        
        googleBooksAPIRepository.error
            .sink(receiveValue: { [weak self] error in
                guard let self else { return }
                print("====ERROR", error)
                self.error = error
                self.stopLoading()
            }).store(in: &cancellables)
    }
    
    public func onDisappear() {
        cancellables.forEach { $0.cancel() }
        books = []
        resultCount = 0
        error = nil
        stopLoading()
    }
}
