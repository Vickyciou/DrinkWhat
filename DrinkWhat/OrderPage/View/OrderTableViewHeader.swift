//
//  OrderTableViewHeader.swift
//  DrinkWhat
//
//  Created by Vickyciou on 2023/7/2.
//

import UIKit

class OrderTableViewHeader: UIView {
    private lazy var shopNameLabel: UILabel = makeShopNameLabel()

    override init(frame: CGRect) {
        super.init(frame: frame)

        addSubview(shopNameLabel)

        NSLayoutConstraint.activate([
            shopNameLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 4),
            shopNameLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            shopNameLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -4)
        ])
    }

    func setupView(shopName: String) {
        shopNameLabel.text = "訂購店家：\(shopName)"
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
extension OrderTableViewHeader {
    private func makeShopNameLabel() -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.font = .medium4()
        label.textColor = UIColor.darkLogoBrown
        return label
    }
}
