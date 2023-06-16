//
//  ShopListToVoteCell.swift
//  DrinkWhat
//
//  Created by Vickyciou on 2023/6/16.
//

import UIKit

class ShopListToVoteCell: UITableViewCell {
    private lazy var shopNameLabel: UILabel = makeLabel()
    private lazy var descriptionLabel: UILabel = makeLabel()
    private lazy var shopImageView: UIImageView = makeImageView()
    private lazy var chooseButton: UIButton = makeButton()
    private lazy var viewMenuButton: UIButton = makeButton()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        let content = [shopNameLabel, descriptionLabel, shopImageView, chooseButton, viewMenuButton]
        content.forEach { contentView.addSubview($0) }
        NSLayoutConstraint.activate([
            shopImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            shopImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            shopImageView.heightAnchor.constraint(equalToConstant: 60),
            shopImageView.widthAnchor.constraint(equalToConstant: 60),
            shopImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            shopNameLabel.topAnchor.constraint(equalTo: shopImageView.topAnchor, constant: 8),
            shopNameLabel.leadingAnchor.constraint(equalTo: shopImageView.trailingAnchor, constant: 8),
            descriptionLabel.topAnchor.constraint(equalTo: shopNameLabel.bottomAnchor, constant: 2),
            descriptionLabel.leadingAnchor.constraint(equalTo: shopNameLabel.leadingAnchor),
            chooseButton.centerYAnchor.constraint(equalTo: shopNameLabel.centerYAnchor),
            chooseButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            chooseButton.heightAnchor.constraint(equalToConstant: 20),
            chooseButton.widthAnchor.constraint(equalToConstant: 20),
            viewMenuButton.bottomAnchor.constraint(equalTo: shopImageView.bottomAnchor),
            viewMenuButton.trailingAnchor.constraint(equalTo: chooseButton.trailingAnchor)
        ])
    }
    func setupVoteCell(shopImage: UIImage?, shopName: String, description: String) {
        shopImageView.image = shopImage
        shopNameLabel.text = shopName
        descriptionLabel.text = description
        shopImageView.layer.cornerRadius = 10
        shopNameLabel.font = .medium(size: 18)
        descriptionLabel.font = .regular(size: 14)
        shopNameLabel.textColor = UIColor.darkBrown
        descriptionLabel.textColor = UIColor.lightBrown
        chooseButton.setImage(UIImage(systemName: "circle"), for: .normal)
        chooseButton.setImage(UIImage(systemName: "circle.inset.filled"), for: .selected)
        viewMenuButton.setTitle("查看菜單 >", for: .normal)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ShopListToVoteCell {
    private func makeLabel() -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }
    private func makeImageView() -> UIImageView {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }
    private func makeButton() -> UIButton {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(UIColor.midiumBrown, for: .normal)
        button.titleLabel?.font = .regular(size: 14)
        return button
    }
}
