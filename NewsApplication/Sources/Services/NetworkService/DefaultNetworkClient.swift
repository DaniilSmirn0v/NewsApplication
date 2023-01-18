//
//  DefaultNetworkClient.swift
//  NewsApplication
//
//  Created by Даниил Смирнов on 18.01.2023.
//

import Foundation

class DefaultNetworkClient: NetworkClientProtocol {
    
    private let urlSession: URLSession
    
    public init(urlSession: URLSession = .shared) {
        self.urlSession = urlSession
    }
    
    func perform<T: Decodable>(request: URLRequest,
                               completion: @escaping (Result<T, NetworkError>) -> Void) {
        
        urlSession.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(.unknown(error)))
            }
            
            if let response = response as? HTTPURLResponse,
               !(200...299).contains(response.statusCode) {
                completion(.failure(.invalidStatusCode(response.statusCode)))
            }
            
            guard let data = data else {
                completion(.failure(NetworkError.emptyData))
                return
            }
            
            do {
                let result = try JSONDecoder().decode(T.self, from: data)
                return completion(.success(result))
            } catch {
                completion(.failure(NetworkError.decoding(error)))
            }
        }.resume()
    }
}
