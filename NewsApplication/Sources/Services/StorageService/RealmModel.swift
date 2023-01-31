//
//  RealmModel.swift
//  NewsApplication
//
//  Created by Даниил Смирнов on 31.01.2023.
//

import Foundation
import RealmSwift

final class RealmCategory: Object {
    @Persisted var category: String
    @Persisted var articles: List<RealmArticle>
}

final class RealmArticle: Object {
    @Persisted var urlString = ""
    @Persisted var imageURL = ""
    @Persisted var title = ""
    
    convenience init(urlString: String,
                     image: String,
                     title: String) {
        self.init()
        
        self.urlString = urlString
        self.imageURL = image
        self.title = title
    }
}
