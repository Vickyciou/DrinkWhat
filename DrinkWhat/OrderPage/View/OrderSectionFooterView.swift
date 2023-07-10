//
//  OrderSectionFooterView.swift
//  DrinkWhat
//
//  Created by Vickyciou on 2023/7/1.
//

import UIKit

class OrderSectionFooterView: UIView {
    private let borderView = UIView(frame: .zero)
    private let priceLabel = UILabel()
    override init(frame: CGRect) {
        super.init(frame: frame)

        addSubview(borderView)
        addSubview(priceLabel)
        borderView.translatesAutoresizingMaskIntoConstraints = false
        borderView.backgroundColor = .middleBrown

        priceLabel.translatesAutoresizingMaskIntoConstraints = false
        priceLabel.textAlignment = .right
        priceLabel.textColor = .darkLogoBrown
        priceLabel.font = .medium2()
        NSLayoutConstraint.activate([
            borderView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            borderView.heightAnchor.constraint(equalToConstant: 0.5),
            borderView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            borderView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            priceLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
            priceLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 4),
            priceLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -8)
        ])

    }

    func setupView(price: Int) {
        priceLabel.text = "$ \(price)"
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
