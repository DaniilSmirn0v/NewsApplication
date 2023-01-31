//
//  StorageService.swift
//  NewsApplication
//
//  Created by Даниил Смирнов on 30.01.2023.
//

import Foundation
import RealmSwift

protocol StorageServiceProtocol {
    func obtainArticles() -> [Category: News]
    func saveCategoryArticles(data: [Article], category: Category.RawValue)
}

final class StorageService: StorageServiceProtocol {
    
    //MARK: - Properties
    private let storage: Realm?
    private var news: [Category: News] = [:]
    
    //MARK: - Initialize
    init(configuration: Realm.Configuration = Realm.Configuration.defaultConfiguration) {
        self.storage = try? Realm(configuration: configuration)
    }
    
    //MARK: - StorageServiceProtocol methods
    func obtainArticles() -> [Category: News] {
        var dataFromRealm: [Category: News] = [:]
        do {
            let realm = try Realm()
            realm.objects(RealmCategory.self).forEach { realmCategory in
                dataFromRealm = convertFromRealm(object: realmCategory)
            }
        } catch let error {
            print("Error: \(error.localizedDescription)")
        }
        return dataFromRealm
    }
    
    func saveCategoryArticles(data: [Article], category: Category.RawValue) {
        let realmCategories = convertToRealm(object: data, category: category)
        do {
            let realm = try Realm()
            try realm.write {
                realm.add(realmCategories)
            }
        } catch let error {
            print("Error: \(error.localizedDescription)")
        }
    }
}

//MARK: - Private methods
extension StorageService {
    private func convertToRealm(object: [Article], category: Category.RawValue) -> RealmCategory {
        let realmCategory = RealmCategory()
        let realmArticles: [RealmArticle] = object.map { article in
            RealmArticle(urlString: article.url,
                         image: article.urlToImage ?? "",
                         title: article.title)
        }
        realmCategory.category = category
        realmCategory.articles.append(objectsIn: realmArticles)
        
        return realmCategory
    }
    
    private func convertFromRealm(object: RealmCategory) -> [Category: News]  {
        var articles = [Article]()
        object.articles.forEach { articleRealm in
            let article = Article(title: articleRealm.title,
                                  url: articleRealm.urlString,
                                  urlToImage: articleRealm.imageURL )
            
            articles.append(article)
        }
        guard let category = Category(rawValue: object.category) else { return [:] }
        news[category] = News(articles: articles)
        
        return news
    }
}

