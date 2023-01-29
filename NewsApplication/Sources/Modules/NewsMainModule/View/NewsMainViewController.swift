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
    
    //MARK: - Views
    private var newsView: NewsCollectionView! {
        guard isViewLoaded else { return nil }
        return view as? NewsCollectionView
    }
    
    private let searchControllerView: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search News here"
        return searchController
    }()
    
    private lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = .black
        refreshControl.attributedTitle = NSAttributedString(string: "Refreshing")
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)

        return refreshControl
    }()
    
    //MARK: - Properties
    private var dataSource: DataSource?
    let presenter: NewsMainPresenterInputProtocol
    
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
        presenter.fetchNewsData(completion: nil)
        createDataSource()
    }
    
    //MARK: - Private methods
    private func setupView() {
        title = "News"
        navigationItem.searchController = searchControllerView
        searchControllerView.searchResultsUpdater = self
        newsView.collectionView.delegate = self
        newsView.collectionView.refreshControl = refreshControl
    }
    
    @objc private func refreshData() {
        DispatchQueue.main.async {
            self.presenter.fetchNewsData(completion: self.refreshControl.endRefreshing())
        }
    }
}

//MARK: - NewsMainPresenterOutputProtocol
extension NewsMainViewController: NewsMainPresenterOutputProtocol {
    func configureView(with viewModel: NewsMainDTO.GetNews.ViewModel) {
        dataSource?.apply(viewModel.snapshot)
    }
    
    func configureAlert(with error: NetworkError) {
        let okAction = UIAlertAction(title: "Okey:<", style: .default) { _ in
            self.presenter.fetchNewsData(completion: nil)
        }
        
        DispatchQueue.main.async {
            self.showAlert(title: "Something went wrong...",
                           message: "\(error.errorDescription)",
                           actions: [okAction])
        }
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

