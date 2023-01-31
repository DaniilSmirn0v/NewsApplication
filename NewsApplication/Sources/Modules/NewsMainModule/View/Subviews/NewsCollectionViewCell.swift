//
//  NewsCollectionViewCell.swift
//  NewsApplication
//
//  Created by Даниил Смирнов on 17.01.2023.
//

import UIKit

final class NewsCollectionViewCell: UICollectionViewCell {
    //MARK: - Properties
    static let reuseId = "NewsCollectionViewCell"
    private let imageLoaderService = ImageLoaderService.shared
    private let gradientLayer = CAGradientLayer()
    private var imageUrl: String?
    
    //MARK: - Views
    var newsImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 14
        return imageView
    }()
    
    var newsTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        label.textAlignment = .right
        label.textColor = .white
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    var activityIndicatorView: UIActivityIndicatorView = {
        let activityIndicatorView = UIActivityIndicatorView(style: .medium)
        activityIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        activityIndicatorView.color = .black
        activityIndicatorView.hidesWhenStopped = true
        
        return activityIndicatorView
    }()
    
    //MARK: - Initialize
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupHierarchy()
        setupGradient()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageUrl = nil
        newsImageView.image = nil
        newsTitleLabel.text = nil
    }
}

//MARK: - Private methods
extension NewsCollectionViewCell {
    private func setupHierarchy() {
        [
            newsImageView,
            activityIndicatorView,
            newsTitleLabel
        ].forEach { addSubview($0) }
    }
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
            activityIndicatorView.centerXAnchor.constraint(equalTo: centerXAnchor),
            activityIndicatorView.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            newsImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            newsImageView.topAnchor.constraint(equalTo: topAnchor),
            newsImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            newsImageView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            newsTitleLabel.leadingAnchor.constraint(equalTo: newsImageView.leadingAnchor, constant: 8),
            newsTitleLabel.topAnchor.constraint(equalTo: newsImageView.topAnchor, constant: 8),
            newsTitleLabel.trailingAnchor.constraint(equalTo: newsImageView.trailingAnchor, constant: -8),
            newsTitleLabel.bottomAnchor.constraint(equalTo: newsImageView.bottomAnchor, constant: -8)
        ])
    }
    
    private func setupGradient() {
        newsImageView.layer.addSublayer(gradientLayer)
        gradientLayer.colors = [
            UIColor.black.withAlphaComponent(0.2).cgColor,
            UIColor.black.withAlphaComponent(0.9).cgColor
        ]
        gradientLayer.frame = bounds
    }
}

extension NewsCollectionViewCell: NewsCollectionViewCellConfigurableProtocol {
    func configure(with viewModel: ViewModel) {
        guard let viewModel = viewModel as? NewsCollectionViewModel else { return }
        activityIndicatorView.startAnimating()
        self.imageUrl = viewModel.imageUrl
        
        newsTitleLabel.text = viewModel.newsTitle
        downloadImage(urlString: viewModel.imageUrl)
        
    }
    
    private func downloadImage(urlString: String) {
        imageLoaderService.image(from: urlString) { image in
            DispatchQueue.main.async { [weak self] in
                guard let self = self,
                      self.imageUrl == urlString else {
                    return
                }
                
                self.newsImageView.image = image
                
                if self.newsImageView.image != nil {
                    self.activityIndicatorView.stopAnimating()
                }
            }
        }
    }
}
