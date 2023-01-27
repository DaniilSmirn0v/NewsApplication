//
//  NewsMainViewController.swift
//  NewsApplication
//
//  Created by Даниил Смирнов on 17.01.2023.
//

import UIKit

class NewsMainViewController: UIViewController {
    
    //MARK: - typealias
    typealias DataSource = UICollectionViewDiffableDataSource<Category, NewsCollectionViewModel>
    public typealias Snapshot = NSDiffableDataSourceSnapshot<Category, NewsCollectionViewModel>
    
    //MARK: - Properties
    private var newsView: NewsCollectionView! {
        guard isViewLoaded else { return nil }
        return view as? NewsCollectionView
    }
    
    private let searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Articles"
        return searchController
    }()
    
    let presenter: NewsMainPresenterInputProtocol
    
    private var dataSource: DataSource?
    
    
    //MARK: - Initialize
    init(presenter: NewsMainPresenterInputProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Lifecycle
    override func loadView() {
        view = NewsCollectionView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        createDataSource()
        presenter.fetchNewsData()
    }
    
    private func setupView() {
        title = "News"
        navigationItem.searchController = searchController
        searchController.searchResultsUpdater = self
        newsView.collectionView.delegate = self
    }
}

//MARK: - NewsMainPresenterOutputProtocol
extension NewsMainViewController: NewsMainPresenterOutputProtocol {
    func configureView(with viewModel: NewsMainDTO.GetNews.ViewModel) {
        dataSource?.apply(viewModel.snapshot)
    }
    
    func configureAlert(with error: NetworkError) {
        //TODO: - configureAlert
    }
    
    func didSelectArticle(with url: String) {
        presenter.didSegueToArticle(with: url)
    }
}

//MARK: - UICollectionViewDiffableDataSource
extension NewsMainViewController {
    
    func createDataSource() {
        dataSource = DataSource(collectionView: newsView.collectionView,
                                cellProvider: { collectionView, indexPath, itemIdentifier in
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: NewsCollectionViewCell.reuseId, for: indexPath) as? NewsCollectionViewCell else {
                return UICollectionViewCell()
            }
            cell.configure(with: itemIdentifier)
            return cell
        })
        
        dataSource?.supplementaryViewProvider = { [weak self] (collectionView, kind, indexPath) -> UICollectionReusableView? in
            guard let section = self?.dataSource?.sectionIdentifier(for: indexPath.section),
                  let header = collectionView.dequeueReusableSupplementaryView(
                    ofKind: UICollectionView.elementKindSectionHeader,
                    withReuseIdentifier: HeaderCollectionReusableView.reuseId,
                    for: indexPath) as? HeaderCollectionReusableView else {
                return UICollectionReusableView()
            }
            header.headerLabel.text = section.rawValue
            return header
        }
    }
}

//MARK: - UICollectionViewDelegate
extension NewsMainViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let item = dataSource?.itemIdentifier(for: indexPath) else { return }
        didSelectArticle(with: item.url)
        collectionView.deselectItem(at: indexPath, animated: true)
    }
}

//MARK: - UISearchResultsUpdating Delegate
extension NewsMainViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        if !searchController.searchBar.text.isEmptyOrNil {
            guard let searchText = searchController.searchBar.text else { return }
            presenter.searchArticle(request: .init(predicate: searchText))
        } else {
            presenter.getDefaulConfigureCell()
        }
    }
}

