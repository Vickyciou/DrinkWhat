//
//  DrinkDetailTopView.swift
//  DrinkWhat
//
//  Created by Vickyciou on 2023/6/27.
//

import UIKit

class DrinkDetailTopView: UIView {
    private lazy var drinkNameLabel: UILabel = makeDrinkNameLabel()
    private lazy var priceLabel: UILabel = makeLabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white

        let content = [drinkNameLabel, priceLabel]
        content.forEach { self.addSubview($0) }
        NSLayoutConstraint.activate([
            drinkNameLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 16),
            drinkNameLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            drinkNameLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            priceLabel.topAnchor.constraint(equalTo: drinkNameLabel.bottomAnchor, constant: 8),
            priceLabel.leadingAnchor.constraint(equalTo: drinkNameLabel.leadingAnchor),
            priceLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -16)
        ])
    }

    func setupTopView(drinkName: String, price: Int) {
        drinkNameLabel.text = drinkName
        priceLabel.text = "$ \(price)"
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension DrinkDetailTopView {
    private func makeDrinkNameLabel() -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.font = .title1()
        label.textColor = UIColor.middleDarkBrown
        return label
    }
    private func makeLabel() -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.font = .regular1()
        label.textColor = UIColor.logoBrown
        return label
    }
}
