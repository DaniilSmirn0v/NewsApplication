//
//  DefaultNetworkClient.swift
//  NewsApplication
//
//  Created by Даниил Смирнов on 18.01.2023.
//

import Foundation

final class DefaultNetworkClient: NetworkClientProtocol {
    
    //MARK: - Properties
    private static let decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        return decoder
    }()
    
    private let urlSession: URLSession
    
    //MARK: - Initialize
    public init(urlSession: URLSession = .shared) {
        self.urlSession = urlSession
    }
    
    //MARK: - NetworkClientProtocol
    func fetchHeadlinersNewsData(from request: URLRequest,
                                 completion: @escaping (Result<News, NetworkError>) -> Void) {
        perform(request: request, completion: completion)
    }
}

    //MARK: - Private methods
extension DefaultNetworkClient {
    private func perform<T: Decodable>(request: URLRequest,
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
                let result = try Self.decoder.decode(T.self, from: data)
                completion(.success(result))
            } catch {
                completion(.failure(NetworkError.decoding(error)))
            }
        }.resume()
    }
}
