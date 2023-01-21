//
//  NewsMainPresenter.swift
//  NewsApplication
//
//  Created by Даниил Смирнов on 18.01.2023.
//

import Foundation

import UIKit

class NewsMainPresenter: NewsMainPresenterInputProtocol {
    
    //MARK: - Properties
    weak var view: NewsMainPresenterOutputProtocol?
    private let networkService: NetworkClientProtocol

    private var results = [Category: News]()
    
    //MARK: - Initialize
    init(networkService: NetworkClientProtocol) {
        self.networkService = networkService
    }
    
    //MARK: - NewsMainPresenterInputProtocol methods
    
    func fetchNewsData() {
        let group = DispatchGroup()
        let categories = Category.allCases
        var news: [Category: News] = [:]
        
        for category in categories {
            group.enter()
            
            let request = NewsRequestFactory.headlinersRequest(category: category.rawValue).urlRequest
            networkService.fetchNewsData(from: request) { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let data):
                    news[category] = data
                case .failure(let error):
                    self.view?.configureAlert(with: error)
                }
                group.leave()
            }
        }
        
        group.notify(queue: .global(qos: .utility)) {
            self.prepareDataToConfigureCell(responce: .init(result: news))
        }
    }
    
    
    func didSelectListItem(with order: Article) {
        //TODO: - 123
    }
    
    //MARK: - Private methods
    private func prepareDataToConfigureCell(responce: NewsMainDTO.GetNews.Response) {
        var snapshot = NSDiffableDataSourceSnapshot<Category, NewsCollectionViewModel>()
        snapshot.appendSections(Category.allCases)

        for (category, news) in responce.result {
            let cellsViewModels = news.articles.map {
                NewsCollectionViewModel(newsTitle: $0.title ?? "")
            }
            print(category)
            snapshot.appendItems(cellsViewModels, toSection: category)
        }

        view?.configureView(with: .init(snapshot: snapshot))
    }

//    func searchArticle(request: NewsMainDTO.SearchNews.Request) {
//        var snapshot = NSDiffableDataSourceSnapshot<Category, NewsCollectionViewModel>()
//        snapshot.appendSections(Category.allCases)
//
//        for (category, news) in results {
//            let cellsViewModels = news.articles.filter { article in
////                article.description?.contains(where: $0.description == request.predicate)
//                return true
//            }
//                .map {
//                    NewsCollectionViewModel(newsTitle: $0.description ?? "")
//                }
//            snapshot.appendItems(cellsViewModels, toSection: category)
//        }
//        view?.configureView(with: .init(snapshot: snapshot))
//    }
}

enum NewsMainDTO {

    enum GetNews {
        struct Request {}

        struct Response {
            let result: [Category: News]
        }

        struct ViewModel {
            let snapshot: NSDiffableDataSourceSnapshot<Category, NewsCollectionViewModel>
        }
    }

    enum SearchNews {
        struct Request {
            let predicate: String
        }
        struct Response {

        }
        struct ViewModel {
            let filtered: NSDiffableDataSourceSnapshot<Category, NewsCollectionViewModel>
        }
    }
}
