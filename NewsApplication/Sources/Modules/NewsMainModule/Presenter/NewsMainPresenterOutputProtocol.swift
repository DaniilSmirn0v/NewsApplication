//
//  NewsMainPresenterOutputProtocol.swift
//  NewsApplication
//
//  Created by Даниил Смирнов on 18.01.2023.
//

import Foundation

protocol NewsMainPresenterOutputProtocol: AnyObject {
    func configureView(with viewModel: NewsMainDTO.GetNews.ViewModel)
    func configureAlert(with error: NetworkError)
    func didSelect(item: NewsCollectionViewModel)
}
