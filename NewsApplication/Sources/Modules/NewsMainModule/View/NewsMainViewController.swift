//
//  NewsMainViewController.swift
//  NewsApplication
//
//  Created by Даниил Смирнов on 17.01.2023.
//

import UIKit

class NewsMainViewController: UIViewController {
    //MARK: - Properties
    private var newsView: NewsCollectionView? {
        guard isViewLoaded else { return nil }
        return view as? NewsCollectionView
    }
    
    let api = ApiUrlFactory.headliners(category: "business")
    let nw = DefaultNetworkClient()
    //MARK: - Lifecycle
    override func loadView() {
        view = NewsCollectionView()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        nw.fetchData { result in
            
            DispatchQueue.main.async {
                switch result {
                    
                case .success(let data):
                    print(data)
                    data.articles.count
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
    
    private func setupView() {
        newsView?.collectionView.delegate = self
        newsView?.collectionView.dataSource = self
        navigationController?.navigationBar.prefersLargeTitles = true
        title = "News"
    }
}

//MARK: - UICollectionViewDataSource
extension NewsMainViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        20
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NewsCollectionViewCell.reuseId, for: indexPath) as? NewsCollectionViewCell else { return UICollectionViewCell() }
        cell.newsImage.image = UIImage(named: "notFoundBlack")
        return cell
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        20
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HeaderCollectionReusableView.reuseId, for: indexPath) as? HeaderCollectionReusableView else {
            return UICollectionReusableView()
        }
        header.headerLabel.text = "hey, i am header"
        return header
    }
    
    
}

//MARK: - UICollectionViewDelegate
extension NewsMainViewController: UICollectionViewDelegate {
    
}


