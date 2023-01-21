//
//  Article.swift
//  NewsApplication
//
//  Created by Даниил Смирнов on 18.01.2023.
//

import Foundation

// MARK: - Welcome
struct News: Codable {
    let articles: [Article]
}

// MARK: - Article
struct Article: Codable {
    let title: String
    let description: String?
    let url: String
    let urlToImage: String?
    let publishedAt: String
}

enum Category: String, CaseIterable {
    case business
    case entertainment
    case general
    case health
    case science
    case sports
    case technology
}
