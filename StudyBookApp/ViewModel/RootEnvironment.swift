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
    
    static let shared = RootEnvironment()
    
    
    
    @Published private(set) var categorys: [Category] = []
    @Published private(set) var books: [Book] = []
    @Published var currentCategory: Category?
    private var cancellables = Set<AnyCancellable>()
    private var realmRepository: RealmRepository

    
    init(repositoryDependency: RepositoryDependency = RepositoryDependency()) {
        realmRepository = repositoryDependency.realmRepository
        
        // 未選択カテゴリが存在しないなら
        if !hasCategory(categoryId: Category.unSelectCategry.id) {
            // アプリ起動時に未選択用のカテゴリを保存する
            realmRepository.createObject(Category.unSelectCategry)
        }
        
    }
    
    public func onAppear() {
        fetchAllData()
    }
    
    public func onDisappear() {
        cancellables.forEach { $0.cancel() }
    }
    
    /// カテゴリ名取得
    public func getCategoryName(_ id: ObjectId) -> String? {
        categorys.first(where: { $0.id == id })?.name
    }
}

// MARK: Realm DataBase
extension RootEnvironment {
    
    // MARK: Book
    public func createBook(_ book: Book) {
        guard let url = book.secureThumbnailUrl else {
            // URLがない場合でもローカル保存は実行
            addBookInCategory(categoryId: book.categoryId, book: book)
            return
        }
        /// ローカルにサムネイル画像を保存する
        AppManager.sharedImageFileManager.savingImage(name: book.id, urlStr: url.absoluteString)
            .sink { _ in } receiveValue: { [weak self] _ in
                guard let self else { return }
                // 成功してからローカルに保存する
                self.addBookInCategory(categoryId: book.categoryId, book: book)
            }.store(in: &cancellables)
    }
    
    public func updateBook(newCategoryId: ObjectId, oldCategoryId: ObjectId, bookId: String, updateBook: Book) {
        // カテゴリの変更がない場合
        if newCategoryId == oldCategoryId {
            realmRepository.updateObject(Category.self, id: oldCategoryId) { category in
                if let book = category.books.first(where: { $0.id == bookId }) {
                    book.title = updateBook.title
                    book.authors = updateBook.authors
                    book.desc = updateBook.desc
                    book.createdAt = updateBook.createdAt
                    book.amount = updateBook.amount
                    book.memo = updateBook.memo
                }
            }
        } else {
            // 変更された場合はBookをローカルから削除する
            // この段階で古いCategoryのbooksプロパティからも削除される
            realmRepository.removeObjs(list: [updateBook])
            // 新しい方へ登録する
            realmRepository.updateObject(Category.self, id: newCategoryId) { category in
                category.books.append(updateBook)
            }
        }
       
        fetchAllData()
    }
    
    public func deleteBook(_ book: Book) {
        /// ローカルにサムネイル画像を保存する
        AppManager.sharedImageFileManager.deleteImage(name: book.id)
            .sink { _ in } receiveValue: { [weak self] _ in
                guard let self else { return }
                // 成功してからローカルに保存する
                self.realmRepository.removeObjs(list: [book])
            }.store(in: &cancellables)
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
        fetchAllData()
    }
    
    public func updateCategory(categoryId: ObjectId, name: String, memo: String) {
        realmRepository.updateObject(Category.self, id: categoryId) { category in
            category.name = name
            category.memo = memo
        }
        fetchAllData()
    }
    
    public func addBookInCategory(categoryId: ObjectId, book: Book) {
        realmRepository.updateObject(Category.self, id: categoryId) { category in
            category.books.append(book)
        }
        fetchAllData()
    }
    
    
    public func hasCategory(categoryId: ObjectId) -> Bool {
        let categorys: [Category] = realmRepository.readAllObjs()
        return categorys.contains(where: { $0.id == categoryId })
    }
    
    public func fetchAllData() {
        categorys = realmRepository.readAllObjs()
        books = categorys.flatMap({ $0.books })
        if let id = currentCategory?.id {
            currentCategory = categorys.first { $0.id == id }
        }
    }
    
    
    public func deleteCategory(_ category: Category) {
        category.books.forEach {
            deleteBook($0)
        }
        realmRepository.removeObjs(list: [category])
        fetchAllData()
    }
    
    public func deleteCategorys() {
        realmRepository.removeObjs(list: categorys)
    }
    
   
    public func calcSumAmount(books: [Book]) -> Int {
        let sum = books.reduce(0) { $0 + $1.amount }
        if sum == -1 { return 0 }
        return sum
    }
}
