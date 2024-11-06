//
//  RootEnvironment.swift
//  StudyBookApp
//
//  Created by t&a on 2024/11/02.
//

import UIKit
import Combine
import RealmSwift

/// アプリ内で共通で利用される状態や環境値を保持する
class RootEnvironment: ObservableObject {
    
    @Published private(set) var categorys: [Category] = []
    @Published private(set) var books: [Book] = []
    @Published var currentBook: Book?
    private var cancellables = Set<AnyCancellable>()
    private var realmRepository: RealmRepository
    
    init(repositoryDependency: RepositoryDependency = RepositoryDependency()) {
        realmRepository = repositoryDependency.realmRepository
    }
    
    public func onAppear() {
        readAllBooks()
        readAllCategorys()
    }
    
    public func onDisappear() {
        cancellables.forEach { $0.cancel() }
    }
}

// MARK: Realm DataBase
extension RootEnvironment {
    
    // MARK: Book
    public func createBook(_ book: Book) {
        guard let url = book.secureThumbnailUrl else { return }
        /// ローカルにサムネイル画像を保存する
        AppManager.sharedImageFileManager.savingImage(name: book.id, urlStr: url.absoluteString)
            .sink { _ in } receiveValue: { [weak self] _ in
                self?.realmRepository.createObject(book)
                self?.readAllBooks()
            }.store(in: &cancellables)
    
    }
    
    public func filteringAllBooks(categoryId: String) {
        books = realmRepository.readAllObjs()
        books = books.filter { $0.categoryId == categoryId}
    }
    
    public func readAllBooks() {
        books = realmRepository.readAllObjs()
    }
    
    public func updateBook(id: String, book: Book) {
      //  realmRepository.updateBook(id: id, newBook: book)
    }
    
    public func deleteBook(_ book: Book) {
        realmRepository.removeObjs(list: [book])
        readAllBooks()
    }
    
    public func deleteAllBooks() {
        realmRepository.removeObjs(list: books)
    }
    
    // MARK: Category
    public func createCategory(name: String, memo: String) {
        let category = Category()
        category.name = name
        category.memo = memo
        realmRepository.createObject(category)
        readAllCategorys()
    }
    
    public func updateCategory(categoryId: ObjectId, name: String, memo: String) {
        realmRepository.updateObject(Category.self, id: categoryId) { category in
            category.name = name
            category.memo = memo
        }
        readAllCategorys()
    }
    
    public func readAllCategorys() {
        categorys = realmRepository.readAllObjs()
    }
    
    
    public func deleteCategory(_ category: Category) {
        realmRepository.removeObjs(list: [category])
        readAllCategorys()
    }
    
    public func deleteCategorys() {
        realmRepository.removeObjs(list: categorys)
    }
}
