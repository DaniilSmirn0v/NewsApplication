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
            return "Ошибка \(statusCode)"
        case .emptyData:
            return "Данные отсутствуют"
        case .decoding(let error):
            return "Ошибка преобразования данных \(error.localizedDescription)"
        case .unknown(let error):
            return "Неизвестная ошибка \n\(error.localizedDescription)"
        }
    }
}
