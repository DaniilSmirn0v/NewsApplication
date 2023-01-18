//
//  NetworkClientProtocol.swift
//  NewsApplication
//
//  Created by Даниил Смирнов on 18.01.2023.
//

import Foundation

protocol NetworkClientProtocol {
    func perform<T: Decodable>(request: URLRequest, completion: @escaping (Result<T, NetworkError>) -> Void)
}
