//
//  RouterProtocol.swift
//  NewsApplication
//
//  Created by Даниил Смирнов on 23.01.2023.
//

import Foundation

protocol RouterProtocol {
    func initialViewController()
    func presentArticleInSafari(with urlString: String)
}
