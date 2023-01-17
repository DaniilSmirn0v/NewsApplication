//
//  HeaderCollectionReusableView.swift
//  NewsApplication
//
//  Created by Даниил Смирнов on 17.01.2023.
//

import UIKit

class HeaderCollectionReusableView: UICollectionReusableView {
    //MARK: - Properties
    static let reuseId = "UICollectionReusableView"

    //MARK: - Views
    var headerLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "header label"
        label.font = .systemFont(ofSize: 22, weight: .bold)
        label.textColor = .black
        return label
    }()

    //MARK: - Initialize
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupHierarchy()
        setupLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension HeaderCollectionReusableView {
    private func setupHierarchy() {
        [
            headerLabel
        ].forEach { addSubview($0) }
    }

    private func setupLayout() {
        NSLayoutConstraint.activate([
            headerLabel.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            headerLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            headerLabel.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}

