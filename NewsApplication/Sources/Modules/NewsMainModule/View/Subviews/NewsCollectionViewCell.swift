//
//  NewsCollectionViewCell.swift
//  NewsApplication
//
//  Created by Даниил Смирнов on 17.01.2023.
//

import UIKit

class NewsCollectionViewCell: UICollectionViewCell {
    //MARK: - Properties
    static let reuseId = "NewsCollectionViewCell"
    let gradientLayer = CAGradientLayer()

    //MARK: - Views
    var newsImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 14
        return imageView
    }()

    var newsTitle: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        label.textAlignment = .right
        label.textColor = .white
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
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

}

//MARK: - Private methods
extension NewsCollectionViewCell {
    private func setupHierarchy() {
        [
            newsImage,
            newsTitle,
        ].forEach { addSubview($0) }
    }

    private func setupLayout() {
        NSLayoutConstraint.activate([
            newsImage.leadingAnchor.constraint(equalTo: leadingAnchor),
            newsImage.topAnchor.constraint(equalTo: topAnchor),
            newsImage.trailingAnchor.constraint(equalTo: trailingAnchor),
            newsImage.bottomAnchor.constraint(equalTo: bottomAnchor),

            newsTitle.leadingAnchor.constraint(equalTo: newsImage.leadingAnchor, constant: 8),
            newsTitle.topAnchor.constraint(equalTo: newsImage.topAnchor, constant: 8),
            newsTitle.trailingAnchor.constraint(equalTo: newsImage.trailingAnchor, constant: -8),
            newsTitle.bottomAnchor.constraint(equalTo: newsImage.bottomAnchor, constant: -8)
        ])
    }

    private func setupGradient() {
        newsImage.layer.addSublayer(gradientLayer)
        gradientLayer.colors = [UIColor.black.withAlphaComponent(0.2).cgColor, UIColor.black.withAlphaComponent(0.9).cgColor]
        gradientLayer.frame = bounds
    }
}

extension NewsCollectionViewCell: NewsCollectionViewCellConfigurableProtocol {
    func configure(with viewModel: ViewModel) {
        guard let viewModel = viewModel as? NewsCollectionViewModel else { return }
        newsTitle.text = viewModel.newsTitle
//        newsImage.image = UIImage(data: viewModel.newsImage)
    }
}
