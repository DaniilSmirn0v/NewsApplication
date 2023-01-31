//
//  NetworkClientProtocol.swift
//  NewsApplication
//
//  Created by Даниил Смирнов on 18.01.2023.
//

import Foundation

protocol NetworkClientProtocol {
    func fetchHeadlinersNewsData(from request: URLRequest,
                                 completion: @escaping (Result<News, NetworkError>) -> Void)
}
