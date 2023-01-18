//
//  NewsRequestFactory.swift
//  NewsApplication
//
//  Created by Даниил Смирнов on 18.01.2023.
//

import Foundation

enum NewsRequestFactory {
    case headlinersRequest(category: String)
    case everythingRequest(title: String)
    
    var urlReques: URLRequest {
        switch self {
        case .headlinersRequest(let category):
            return createRequest(url: ApiUrlFactory.headliners(category: category).url)
        case .everythingRequest(let title):
            return createRequest(url: ApiUrlFactory.everything(title: title).url)
        }
    }
    
    private func createRequest(url: URL) -> URLRequest {
        var request = URLRequest(url: url)
        request.cachePolicy = .returnCacheDataElseLoad
        request.timeoutInterval = 10
        return request
    }
}
