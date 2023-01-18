//
//  ApiUrlFactory.swift
//  NewsApplication
//
//  Created by Даниил Смирнов on 18.01.2023.
//

import Foundation

enum ApiUrlFactory {
    case headliners(category: String)
    case everything(title: String)
    
    var url: URL {
        switch self {
        case .headliners(let category):
            return configureUrl(with: DefaultComponents.baseUrl, endpoint: DefaultComponents.headlinersPath,
                                queryParametrs: ["country": "us",
                                                 "category": "\(category)",
                                                 "sortBy": "publishedAt",
                                                 "apiKey": "\(DefaultComponents.apiKey)"])
        case .everything(let title):
            return configureUrl(with: DefaultComponents.baseUrl,
                                endpoint: DefaultComponents.everythingPath,
                                queryParametrs: ["q": "\(title)",
                                                 "sortBy": "popularity"])
        }
    }
    
    private func configureUrl(with baseURL: String,
                              endpoint: String,
                              queryParametrs: [String: Any]) -> URL {
        guard let url = URL(string: baseURL)?.appendingPathComponent(endpoint),
              var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: true) else {
            return URL(fileURLWithPath: "")
        }
        
        urlComponents.queryItems = queryParametrs.map {
            URLQueryItem(name: $0, value: "\($1)")
        }
        guard let url = urlComponents.url else { return URL(fileURLWithPath: "") }
        return url
    }
}
