//
//  MainOrderCell.swift
//  DrinkWhat
//
//  Created by Vickyciou on 2023/6/30.
//

import UIKit

class MainOrderCell: UITableViewCell {
    private lazy var shopNameLabel: UILabel = makeShopNameLabel()
    private lazy var descriptionLabel: UILabel = makeLabel()
    private lazy var dateLabel: UILabel = makeLabel()
    private lazy var shopImageView: UIImageView = makeShopImageView()
    private lazy var arrowImageView: UIImageView = makeArrowImageView()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        let content = [shopNameLabel, descriptionLabel, dateLabel, shopImageView, arrowImageView]
        content.forEach { contentView.addSubview($0) }
        NSLayoutConstraint.activate([
            shopImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            shopImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            shopImageView.heightAnchor.constraint(equalToConstant: 60),
            shopImageView.widthAnchor.constraint(equalToConstant: 60),
            shopImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            shopNameLabel.topAnchor.constraint(equalTo: shopImageView.topAnchor, constant: 8),
            shopNameLabel.leadingAnchor.constraint(equalTo: shopImageView.trailingAnchor, constant: 8),
            dateLabel.topAnchor.constraint(equalTo: shopNameLabel.bottomAnchor, constant: 2),
            dateLabel.leadingAnchor.constraint(equalTo: shopNameLabel.leadingAnchor),
            descriptionLabel.topAnchor.constraint(equalTo: dateLabel.topAnchor),
            descriptionLabel.leadingAnchor.constraint(equalTo: dateLabel.trailingAnchor, constant: 4),
            arrowImageView.centerYAnchor.constraint(equalTo: shopImageView.centerYAnchor),
            arrowImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            arrowImageView.heightAnchor.constraint(equalToConstant: 15),
            arrowImageView.widthAnchor.constraint(equalToConstant: 15)
        ])
    }
    func setupCell(shopImageURL: String?, shopName: String, description: String, date: String) {
        shopImageView.loadImage(shopImageURL, placeHolder: UIImage(systemName: "bag")?.setColor(color: .darkBrown))
        shopNameLabel.text = shopName
        descriptionLabel.text = description
        dateLabel.text = date
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension MainOrderCell {
    private func makeShopNameLabel() -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.font = .medium(size: 18)
        label.textColor = UIColor.darkBrown
        return label
    }
    private func makeLabel() -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.font = .regular(size: 14)
        label.textColor = UIColor.midiumBrown
        return label
    }
    private func makeShopImageView() -> UIImageView {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 10
        imageView.layer.masksToBounds = true
        return imageView
    }
    private func makeArrowImageView() -> UIImageView {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(systemName: "arrow.right")?.setColor(color: .darkBrown)
        return imageView
    }
}
