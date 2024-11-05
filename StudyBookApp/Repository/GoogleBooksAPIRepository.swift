//
//  GoogleBooksAPIRepository.swift
//  StudyBookApp
//
//  Created by t&a on 2024/11/03.
//

import Alamofire
import SwiftyJSON
import UIKit
import Combine

class GoogleBooksAPIRepository {
    
    /// Google Books API EndPoint
    private let endPoint: String = "https://www.googleapis.com/books/v1/volumes"
    /// クエリ接頭辞
    private let queryPrefix: String = "?"
    /// 最大取得数制限
    private let max: String = "maxResults=30"
    /// APIキー https://qiita.com/ryamate/items/2a0cba391829e20009aa
    private let apiKey: String = ""
    /// キーワードクエリ
    private let query: String = "&q="

    /// リクエストAPIURLの構築
    private func createEndPoint(keyword: String) -> String {
        let urlStr = endPoint + queryPrefix + max + apiKey + query + keyword
        return urlStr
    }
   
    
    public var books: AnyPublisher<[Book], Never> {
        _books.eraseToAnyPublisher()
    }
    private var _books = PassthroughSubject<[Book], Never>()

    /// 日本語をエンコーディング
    private func getEncodingUrl(url: String) -> String {
        guard let encurl = url.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed) else { return "" }
        return encurl
    }

    public func fetchBooks(keyword: String) {
        let endPoint = createEndPoint(keyword: keyword)
        let encUrl = getEncodingUrl(url: endPoint)
        print("----URL：" + encUrl)
        AF.request(encUrl).response { [weak self] response in
            print("-- RESPONSE",response)
            guard let self else { return }
            do {
                guard let data = response.data else { return }
                let json = try JSON(data: data)
                print("-- JSON：", json)
                // APIからエラーが返却された場合は処理を終了する
                if json["error"].exists() {
                    print("--ERROR")
                    return
                }
                
                guard json["totalItems"] != 0 else { return }
                let books = self.convertJsonToBook(json)
                guard !books.isEmpty else { return }
                print("-- BOOKS更新n")
                _books.send(books)
                
            } catch {
                
            }
        }
    }

    private func convertJsonToBook(_ json: JSON) -> [Book] {
        guard let items = json["items"].array else { return [] }
        var books: [Book] = []
        for item in items {
            let bk = Book()
            bk.id = item["id"].stringValue
            bk.title = item["volumeInfo"]["title"].stringValue
            if let authors = item["volumeInfo"]["authors"].array {
                for author in authors {
                    bk.authors.append(author.stringValue)
                }
            }
            bk.desc = item["volumeInfo"]["description"].stringValue
            bk.ISBN_13 = item["volumeInfo"]["industryIdentifiers"][1]["identifier"].stringValue
            bk.pageCount = item["volumeInfo"]["pageCount"].int ?? 0
            bk.publishedDate = item["volumeInfo"]["publishedDate"].stringValue
            bk.thumbnailUrl = item["volumeInfo"]["imageLinks"]["thumbnail"].stringValue
            books.append(bk)
        }
        return books
    }
}
