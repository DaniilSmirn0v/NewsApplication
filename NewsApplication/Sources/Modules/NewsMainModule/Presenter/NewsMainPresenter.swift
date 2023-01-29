//
//  NewsMainPresenter.swift
//  NewsApplication
//
//  Created by Даниил Смирнов on 18.01.2023.
//

import UIKit

class NewsMainPresenter: NewsMainPresenterInputProtocol {
    
    //MARK: - Properties
    weak var view: NewsMainPresenterOutputProtocol?
    private let router: RouterProtocol
    private let networkService: NetworkClientProtocol
    private var news = [Category: News]()
    private let group = DispatchGroup()
    
    
    //MARK: - Initialize
    init(networkService: NetworkClientProtocol,
         router: RouterProtocol) {
        self.networkService = networkService
        self.router = router
    }
    
    //MARK: - NewsMainPresenterInputProtocol methods
    func fetchNewsData(completion: (Void)? = nil) {
        
        Category.allCases.forEach { category in
            
            self.group.enter()
            let request = NewsRequestFactory.headlinersRequest(category: category.rawValue).urlRequest
            networkService.fetchHeadlinersNewsData(from: request) { [weak self] result in
                guard let self = self else { return }
                self.group.enter()
                switch result {
                case .success(let data):
                    self.news[category] = data
                case .failure(let error):
                    self.view?.configureAlert(with: error)
                }
                self.group.leave()
                self.group.notify(queue: .global()) {
                    self.prepareDataToConfigureCell(responce: .init(result: self.news))
                }
            }
            self.group.leave()
        }
    }
    
    func didSegueToArticle(with url: String) {
        router.presentArticleInSafari(with: url)
    }
    
    func searchArticle(request: NewsMainDTO.SearchNews.Request) {
        var snapshot = NSDiffableDataSourceSnapshot<Category, NewsCollectionViewModel>()
        
        for (category, news) in news {
            let cellsViewModels = news.articles.filter { article in
                article.title.lowercased().contains(request.predicate.lowercased())
            }
                .map {
                    NewsCollectionViewModel(newsTitle: $0.title,
                                            url: $0.url,
                                            imageUrl: $0.urlToImage ?? "")
                }
            
            if !cellsViewModels.isEmpty {
                snapshot.appendSections([category])
                snapshot.appendItems(cellsViewModels, toSection: category)
            }
        }
        view?.configureView(with: .init(snapshot: snapshot))
    }
    
    func getDefaulConfigureCell() {
        prepareDataToConfigureCell(responce: .init(result: news))
    }
    
    //MARK: - Private methods
    private func prepareDataToConfigureCell(responce: NewsMainDTO.GetNews.Response) {
        var snapshot = NSDiffableDataSourceSnapshot<Category, NewsCollectionViewModel>()
        snapshot.appendSections(Category.allCases)
        
        for (category, news) in responce.result {
            let cellsViewModels = news.articles.map {
                NewsCollectionViewModel(newsTitle: $0.title,
                                        url: $0.url,
                                        imageUrl: $0.urlToImage ?? ""
                )
            }
            snapshot.appendItems(cellsViewModels, toSection: category)
        }
        view?.configureView(with: .init(snapshot: snapshot))
    }
}
