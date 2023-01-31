//
//  NewsRequestFactory.swift
//  NewsApplication
//
//  Created by Даниил Смирнов on 18.01.2023.
//

import Foundation

enum NewsRequestFactory {
    case headlinersRequest(category: String)
    
    var urlRequest: URLRequest {
        switch self {
        case .headlinersRequest(let category):
            return createRequest(url: ApiUrlFactory.headliners(category: category).url)
        }
    }
    
    private func createRequest(url: URL) -> URLRequest {
        var request = URLRequest(url: url)
        request.cachePolicy = .returnCacheDataElseLoad
        request.timeoutInterval = 20
        return request
    }
}
