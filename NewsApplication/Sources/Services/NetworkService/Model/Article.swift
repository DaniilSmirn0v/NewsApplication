//
//  Article.swift
//  NewsApplication
//
//  Created by Даниил Смирнов on 18.01.2023.
//

import Foundation

// MARK: - Welcome
struct Articles: Decodable {
    let articles: [Article]
}

// MARK: - Article
struct Article: Decodable {
    let description: String?
    let url: String
    let urlToImage: String?
    let publishedAt: String
}
