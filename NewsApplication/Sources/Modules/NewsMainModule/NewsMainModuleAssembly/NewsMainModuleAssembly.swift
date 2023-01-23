//
//  NewsMainModuleAssembly.swift
//  NewsApplication
//
//  Created by Даниил Смирнов on 23.01.2023.
//

import UIKit

class NewsMainModuleAssembly {
    static func createNewsMainModule(router: RouterProtocol) -> UIViewController {
        let networkClient = DefaultNetworkClient()
        let presenter = NewsMainPresenter(networkService: networkClient, router: router)
        let newsMainViewController = NewsMainViewController(presenter: presenter)
        presenter.view = newsMainViewController
        
        return newsMainViewController
    }
}
