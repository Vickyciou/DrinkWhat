//
//  NotVotedCell.swift
//  DrinkWhat
//
//  Created by Vickyciou on 2023/6/16.
//

import UIKit

protocol NotVotedCellDelegate: AnyObject {
    func didPressedViewMenuButton(_ cell: NotVotedCell, button: UIButton)
    func didSelectedChooseButton(_ cell: NotVotedCell, button: UIButton)
}

class NotVotedCell: UITableViewCell {
    private lazy var shopNameLabel: UILabel = makeShopNameLabel()
    private lazy var shopImageView: UIImageView = makeImageView()
    lazy var chooseButton: UIButton = makeChooseButton()
    private lazy var viewMenuButton: UIButton = makeViewMenuButton()
    private lazy var numberOfVotesLabel: UILabel = makeNumberOfVotesLabel()
    weak var delegate: NotVotedCellDelegate?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        let content = [shopNameLabel, shopImageView, chooseButton, viewMenuButton, numberOfVotesLabel]
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
            numberOfVotesLabel.centerYAnchor.constraint(equalTo: shopImageView.centerYAnchor),
            numberOfVotesLabel.trailingAnchor.constraint(equalTo: chooseButton.leadingAnchor, constant: -10),
            numberOfVotesLabel.widthAnchor.constraint(equalToConstant: 40),
            chooseButton.centerYAnchor.constraint(equalTo: shopImageView.centerYAnchor),
            chooseButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            chooseButton.heightAnchor.constraint(equalToConstant: 40),
            chooseButton.widthAnchor.constraint(equalToConstant: 40)
        ])
    }
    func setupVoteCell(shopImage: UIImage?, shopName: String, numberOfVote: Int?) {
        shopImageView.image = shopImage
        shopNameLabel.text = shopName
        numberOfVotesLabel.text = String("\(numberOfVote ?? 0)票")
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension NotVotedCell {
    private func makeShopNameLabel() -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.font = .medium(size: 18)
        label.textColor = UIColor.darkBrown
        return label
    }
    private func makeImageView() -> UIImageView {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 10
        return imageView
    }
    private func makeNumberOfVotesLabel() -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.font = .medium(size: 15)
        label.textColor = UIColor.white
        label.backgroundColor = UIColor.darkBrown
        label.layer.cornerRadius = 6
        label.layer.masksToBounds = true
        label.textAlignment = .center
        return label
    }
    private func makeChooseButton() -> UIButton {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(UIColor.midiumBrown, for: .normal)
        button.titleLabel?.font = .regular(size: 14)
        button.setImage(UIImage(systemName: "circle")?.setColor(color: .darkBrown), for: .normal)
        button.setImage(UIImage(systemName: "circle.inset.filled")?.setColor(color: .darkBrown), for: .selected)
        button.addTarget(self, action: #selector(chooseButtonTapped(_:)), for: .touchUpInside)
        return button
    }
    private func makeViewMenuButton() -> UIButton {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(UIColor.midiumBrown, for: .normal)
        button.titleLabel?.font = .regular(size: 14)
        button.setTitle("查看菜單 >", for: .normal)
        button.addTarget(self, action: #selector(viewButtonTapped(_:)), for: .touchUpInside)
        return button
    }
    @objc func chooseButtonTapped(_ sender: UIButton) {
        delegate?.didSelectedChooseButton(self, button: sender)
    }
    @objc func viewButtonTapped(_ sender: UIButton) {
        delegate?.didPressedViewMenuButton(self, button: sender)
    }
}
