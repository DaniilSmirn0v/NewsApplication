//
//  NewsMainRouter.swift
//  NewsApplication
//
//  Created by Даниил Смирнов on 23.01.2023.
//

import UIKit
import SafariServices

final class NewsMainRouter: RouterProtocol {
    
    //MARK: - Properties
    private var navigationController: UINavigationController
    
    //MARK: - Initialize
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    //MARK: - RouterProtocol methods
    func initialViewController() {
        let newsMainViewController = NewsMainModuleAssembly.createNewsMainModule(router: self)
        navigationController.navigationBar.prefersLargeTitles = true
        navigationController.viewControllers = [newsMainViewController]
    }
    
    func presentArticleInSafari(with urlString: String) {
        if let url = URL(string: urlString) {
            let safariViewController = SFSafariViewController(url: url)
            navigationController.present(safariViewController, animated: true)
        }
    }
}
