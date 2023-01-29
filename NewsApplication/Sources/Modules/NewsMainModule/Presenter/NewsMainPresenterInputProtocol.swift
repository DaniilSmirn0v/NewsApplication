//
//  NewsMainPresenterInputProtocol.swift
//  NewsApplication
//
//  Created by Даниил Смирнов on 18.01.2023.
//

import Foundation

protocol NewsMainPresenterInputProtocol {
    func fetchNewsData(completion: (Void)?)
    func didSegueToArticle(with url: String)
    func searchArticle(request: NewsMainDTO.SearchNews.Request)
    func getDefaulConfigureCell()
}
