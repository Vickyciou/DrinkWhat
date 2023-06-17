//
//  ShopListToVoteCell.swift
//  DrinkWhat
//
//  Created by Vickyciou on 2023/6/16.
//

import UIKit

protocol ShopListToVoteCellDelegate: AnyObject {
    func didPressedViewMenuButton(_ cell: ShopListToVoteCell, button: UIButton)
    func didSelectedChooseButton(_ cell: ShopListToVoteCell, button: UIButton)
}

class ShopListToVoteCell: UITableViewCell {
    private lazy var shopNameLabel: UILabel = makeLabel()
    private lazy var shopImageView: UIImageView = makeImageView()
    lazy var chooseButton: UIButton = makeButton()
    private lazy var viewMenuButton: UIButton = makeButton()
    weak var delegate: ShopListToVoteCellDelegate?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        let content = [shopNameLabel, shopImageView, chooseButton, viewMenuButton]
        content.forEach { contentView.addSubview($0) }
        NSLayoutConstraint.activate([
            shopImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            shopImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            shopImageView.heightAnchor.constraint(equalToConstant: 60),
            shopImageView.widthAnchor.constraint(equalToConstant: 60),
            shopImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            shopNameLabel.topAnchor.constraint(equalTo: shopImageView.topAnchor, constant: 8),
            shopNameLabel.leadingAnchor.constraint(equalTo: shopImageView.trailingAnchor, constant: 8),
            viewMenuButton.bottomAnchor.constraint(equalTo: shopImageView.bottomAnchor),
            viewMenuButton.leadingAnchor.constraint(equalTo: shopNameLabel.leadingAnchor),
            chooseButton.centerYAnchor.constraint(equalTo: shopImageView.centerYAnchor),
            chooseButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            chooseButton.heightAnchor.constraint(equalToConstant: 40),
            chooseButton.widthAnchor.constraint(equalToConstant: 40)
        ])
    }
    func setupVoteCell(shopImage: UIImage?, shopName: String) {
        shopImageView.image = shopImage
        shopNameLabel.text = shopName
        shopImageView.layer.cornerRadius = 10
        shopNameLabel.font = .medium(size: 18)
        shopNameLabel.textColor = UIColor.darkBrown
        let image = UIImage(systemName: "circle")
        chooseButton.setImage(UIImage(systemName: "circle"), for: .normal)
        chooseButton.setImage(UIImage(systemName: "circle.inset.filled"), for: .selected)
        chooseButton.addTarget(self, action: #selector(chooseButtonTapped(_:)), for: .touchUpInside)
        viewMenuButton.setTitle("查看菜單 >", for: .normal)
        viewMenuButton.addTarget(self, action: #selector(viewButtonTapped(_:)), for: .touchUpInside)
    }
    @objc func chooseButtonTapped(_ sender: UIButton) {
        delegate?.didSelectedChooseButton(self, button: sender)
    }
    @objc func viewButtonTapped(_ sender: UIButton) {
        delegate?.didPressedViewMenuButton(self, button: sender)
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
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(UIColor.midiumBrown, for: .normal)
        button.titleLabel?.font = .regular(size: 14)
        return button
    }
}
