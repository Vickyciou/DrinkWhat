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
    private lazy var view: UIView = makeBackgroundView()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        contentView.addSubview(view)
        let contents = [shopNameLabel, descriptionLabel, dateLabel, shopImageView, arrowImageView]
        contents.forEach { view.addSubview($0) }
        NSLayoutConstraint.activate([
            view.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            view.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            view.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            view.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            shopImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 12),
            shopImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            shopImageView.heightAnchor.constraint(equalToConstant: 50),
            shopImageView.widthAnchor.constraint(equalToConstant: 50),
            shopImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -12),
            shopNameLabel.topAnchor.constraint(equalTo: shopImageView.topAnchor, constant: 4),
            shopNameLabel.leadingAnchor.constraint(equalTo: shopImageView.trailingAnchor, constant: 16),
            dateLabel.topAnchor.constraint(equalTo: shopNameLabel.bottomAnchor, constant: 2),
            dateLabel.leadingAnchor.constraint(equalTo: shopNameLabel.leadingAnchor),
            descriptionLabel.topAnchor.constraint(equalTo: dateLabel.topAnchor),
            descriptionLabel.leadingAnchor.constraint(equalTo: dateLabel.trailingAnchor, constant: 4),
            arrowImageView.centerYAnchor.constraint(equalTo: shopImageView.centerYAnchor),
            arrowImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
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
        label.font = .title3()
        label.textColor = UIColor.darkLogoBrown
        return label
    }
    private func makeLabel() -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.font = .regular(size: 14)
        label.textColor = UIColor.middleBrown
        return label
    }
    private func makeShopImageView() -> UIImageView {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 10
        imageView.alpha = 0.9
        imageView.layer.masksToBounds = true
        return imageView
    }
    private func makeArrowImageView() -> UIImageView {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(systemName: "arrow.right")?.setColor(color: .middleDarkBrown)
        return imageView
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
