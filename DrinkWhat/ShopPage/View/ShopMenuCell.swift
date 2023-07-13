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
    private lazy var view: UIView = makeBackgroundView()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        self.selectionStyle = .none
        contentView.addSubview(view)
        let contents = [drinkNameLabel, drinkImageView, drinkPriceLabel]
        contents.forEach { view.addSubview($0) }
        NSLayoutConstraint.activate([
            view.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            view.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            view.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            view.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            drinkImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 16),
            drinkImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            drinkImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -16),
            drinkImageView.heightAnchor.constraint(equalToConstant: 40),
            drinkImageView.widthAnchor.constraint(equalToConstant: 40),
            drinkNameLabel.topAnchor.constraint(equalTo: drinkImageView.topAnchor, constant: -2),
            drinkNameLabel.leadingAnchor.constraint(equalTo: drinkImageView.trailingAnchor, constant: 16),
            drinkNameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
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
        imageView.image = UIImage(named: "DrinkWhat-icon無字版")
        return imageView
    }
    private func makeDrinkNameLabel() -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.font = .medium2()
        label.textColor = UIColor.middleDarkBrown
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

    private func makeBackgroundView() -> UIView {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.layer.cornerRadius = 20
        view.clipsToBounds = false
        view.layer.shadowColor = UIColor.darkLogoBrown.cgColor
        view.layer.shadowOpacity = 0.3
        view.layer.shadowOffset = CGSize(width: 0, height: 1)
        view.layer.shadowRadius = 4
        return view
    }
}
