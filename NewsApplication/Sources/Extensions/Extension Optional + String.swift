//
//  Extension Optional + String.swift
//  NewsApplication
//
//  Created by Даниил Смирнов on 27.01.2023.
//

import Foundation

extension Optional where Wrapped == String {
    
    var isEmptyOrNil: Bool {
        return self?.isEmpty != false
    }
}
