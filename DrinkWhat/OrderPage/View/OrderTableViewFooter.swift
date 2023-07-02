//
//  OrderTableViewFooter.swift
//  DrinkWhat
//
//  Created by Vickyciou on 2023/7/2.
//

import UIKit

class OrderTableViewFooter: UIView {
    private lazy var imageView: UIImageView = makeImageView()
    private lazy var amountLabel: UILabel = makeLabel()

    override init(frame: CGRect) {
        super.init(frame: frame)

        let contents = [imageView, amountLabel]
        contents.forEach { self.addSubview($0) }

        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: topAnchor, constant: 8),
//            imageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24),
            imageView.trailingAnchor.constraint(equalTo: amountLabel.leadingAnchor, constant: -16),
            imageView.heightAnchor.constraint(equalToConstant: 25),
            imageView.widthAnchor.constraint(equalToConstant: 25),
//            imageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8),
            amountLabel.centerYAnchor.constraint(equalTo: imageView.centerYAnchor),
            amountLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            amountLabel.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 16)
        ])
    }
    func setupView(amount: Int) {
        amountLabel.text = "總計$ \(amount)"
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
extension OrderTableViewFooter {
    private func makeImageView() -> UIImageView {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "orderBig")
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }

    private func makeLabel() -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.font = .bold(size: 18)
        label.textColor = UIColor.darkBrown
        return label
    }
}
