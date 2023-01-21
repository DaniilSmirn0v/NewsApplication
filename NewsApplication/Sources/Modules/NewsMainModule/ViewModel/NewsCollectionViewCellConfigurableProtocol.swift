//
//  NewsCollectionViewCellConfigurableProtocol.swift
//  NewsApplication
//
//  Created by Даниил Смирнов on 19.01.2023.
//

import UIKit

protocol NewsCollectionViewCellConfigurableProtocol where Self: UICollectionViewCell {
    func configure(with viewModel: ViewModel)
}
