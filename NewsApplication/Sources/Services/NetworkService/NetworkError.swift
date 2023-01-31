//
//  NetworkError.swift
//  NewsApplication
//
//  Created by Даниил Смирнов on 18.01.2023.
//

import Foundation

enum NetworkError: Error {
    case invalidStatusCode(_ statusCode: Int)
    case emptyData
    case decoding(_ error: Error)
    case unknown(_ error: Error)
    
    var errorDescription: String {
        switch self {
        case .invalidStatusCode(let statusCode):
            return "Error \(statusCode)"
        case .emptyData:
            return "No data"
        case .decoding(let error):
            return "Data conversion error \(error.localizedDescription)"
        case .unknown(let error):
            return "Error: \(error.localizedDescription)"
        }
    }
}
