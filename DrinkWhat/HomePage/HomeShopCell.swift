//
//  HomeShopCell.swift
//  DrinkWhat
//
//  Created by Vickyciou on 2023/6/22.
//

import UIKit

class HomeShopCell: UITableViewCell {
    private lazy var shopNameLabel: UILabel = makeShopNameLabel()
    private lazy var shopImageView: UIImageView = makeShopImageView()
    private lazy var arrowImageView: UIImageView = makeArrowImageView()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        let content = [shopNameLabel, shopImageView, arrowImageView]
        content.forEach { contentView.addSubview($0) }
        NSLayoutConstraint.activate([
            shopImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            shopImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            shopImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            shopImageView.heightAnchor.constraint(equalToConstant: 200),
            shopNameLabel.topAnchor.constraint(equalTo: shopImageView.bottomAnchor, constant: 11),
            shopNameLabel.leadingAnchor.constraint(equalTo: shopImageView.leadingAnchor),
            shopNameLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            arrowImageView.centerYAnchor.constraint(equalTo: shopNameLabel.centerYAnchor),
            arrowImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            arrowImageView.heightAnchor.constraint(equalToConstant: 15),
            arrowImageView.widthAnchor.constraint(equalToConstant: 15)
        ])
    }
    func setupCell(mainImage: String, shopName: String) {
        shopImageView.loadImage(mainImage)
        shopNameLabel.text = shopName
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension HomeShopCell {
    private func makeShopNameLabel() -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.font = .title3()
        label.textColor = UIColor.darkLogoBrown
        return label
    }
    private func makeShopImageView() -> UIImageView {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 10
        return imageView
    }
    private func makeArrowImageView() -> UIImageView {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(systemName: "arrow.right")?.setColor(color: .darkLogoBrown)
        return imageView
    }
}
