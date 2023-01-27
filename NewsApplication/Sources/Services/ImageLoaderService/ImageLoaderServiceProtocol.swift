//
//  ImageLoaderServiceProtocol.swift
//  NewsApplication
//
//  Created by Даниил Смирнов on 23.01.2023.
//

import UIKit

protocol ImageLoaderServiceProtocol {
    func image(from urlString: String, completion: @escaping (UIImage, String) -> Void)
}
