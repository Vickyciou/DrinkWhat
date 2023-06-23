//
//  ShopMenuCell.swift
//  DrinkWhat
//
//  Created by Vickyciou on 2023/6/22.
//

import UIKit

class ShopMenuCell: UITableViewCell {
    private lazy var drinkImageView: UIImageView = makeDrinkImageView()
    private lazy var drinkNameLabel: UILabel = makeDrinkNameLabel()
    private lazy var drinkPriceLabel: UILabel = makeDrinkPriceLabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        let content = [drinkNameLabel, drinkImageView, drinkPriceLabel]
        content.forEach { contentView.addSubview($0) }
        NSLayoutConstraint.activate([
            drinkImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            drinkImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            drinkImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            drinkImageView.heightAnchor.constraint(equalToConstant: 60),
            drinkImageView.widthAnchor.constraint(equalToConstant: 60),
            drinkNameLabel.topAnchor.constraint(equalTo: drinkImageView.topAnchor, constant: 2),
            drinkNameLabel.leadingAnchor.constraint(equalTo: drinkImageView.trailingAnchor, constant: 16),
            drinkNameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            drinkPriceLabel.topAnchor.constraint(equalTo: drinkNameLabel.bottomAnchor, constant: 4),
            drinkPriceLabel.leadingAnchor.constraint(equalTo: drinkNameLabel.leadingAnchor),
            drinkPriceLabel.trailingAnchor.constraint(equalTo: drinkNameLabel.trailingAnchor)
        ])
    }
    func setupCell(drinkName: String, drinkPrice: Int) {
        drinkNameLabel.text = drinkName
        drinkPriceLabel.text = "$ \(drinkPrice)"
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ShopMenuCell {
    private func makeDrinkImageView() -> UIImageView {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 10
//        imageView.image = UIImage(systemName: "mug")?.setColor(color: .darkBrown)
        imageView.image = UIImage(named: "Mug")
        return imageView
    }
    private func makeDrinkNameLabel() -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.font = .medium(size: 18)
        label.textColor = UIColor.darkBrown
        return label
    }
    private func makeDrinkPriceLabel() -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.font = .medium(size: 16)
        label.textColor = UIColor.logoBrown
        return label
    }
}
