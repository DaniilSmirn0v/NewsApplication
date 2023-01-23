//
//  NewsCollectionViewModel.swift
//  NewsApplication
//
//  Created by Даниил Смирнов on 19.01.2023.
//

import Foundation

struct NewsCollectionViewModel: ViewModel, Hashable {
    let id = UUID()
    let newsTitle: String
    let url: String
//    let image: Data
}
