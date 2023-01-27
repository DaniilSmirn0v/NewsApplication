//
//  NewsMainDTO.swift
//  NewsApplication
//
//  Created by Даниил Смирнов on 27.01.2023.
//

import UIKit

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
