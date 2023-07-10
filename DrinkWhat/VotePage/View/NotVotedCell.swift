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
    private lazy var numberLabel: UILabel = makeNumberLabel()
    private lazy var shopNameLabel: UILabel = makeShopNameLabel()
    private lazy var shopImageView: UIImageView = makeImageView()
    lazy var chooseButton: UIButton = makeChooseButton()
    private lazy var viewMenuButton: UIButton = makeViewMenuButton()
    private lazy var numberOfVotesLabel: UILabel = makeNumberOfVotesLabel()
    private lazy var view: UIView = makeBackgroundView()
    weak var delegate: NotVotedCellDelegate?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        contentView.addSubview(view)
        let content = [numberLabel, shopNameLabel, shopImageView, chooseButton, viewMenuButton, numberOfVotesLabel]
        content.forEach { view.addSubview($0) }
        NSLayoutConstraint.activate([
            view.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            view.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            view.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            view.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            numberLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12),
            numberLabel.centerYAnchor.constraint(equalTo: shopImageView.centerYAnchor),
            numberLabel.heightAnchor.constraint(equalToConstant: 28),
            numberLabel.widthAnchor.constraint(equalToConstant: 28),
            shopImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 16),
            shopImageView.leadingAnchor.constraint(equalTo: numberLabel.trailingAnchor, constant: 12),
            shopImageView.heightAnchor.constraint(equalToConstant: 50),
            shopImageView.widthAnchor.constraint(equalToConstant: 50),
            shopImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            shopNameLabel.topAnchor.constraint(equalTo: shopImageView.topAnchor, constant: 4),
            shopNameLabel.leadingAnchor.constraint(equalTo: shopImageView.trailingAnchor, constant: 8),
            shopNameLabel.trailingAnchor.constraint(equalTo: numberOfVotesLabel.leadingAnchor, constant: -8),
            viewMenuButton.bottomAnchor.constraint(equalTo: shopImageView.bottomAnchor, constant: 2),
            viewMenuButton.leadingAnchor.constraint(equalTo: shopNameLabel.leadingAnchor),
            numberOfVotesLabel.centerYAnchor.constraint(equalTo: shopImageView.centerYAnchor),
            numberOfVotesLabel.trailingAnchor.constraint(equalTo: chooseButton.leadingAnchor, constant: -4),
            numberOfVotesLabel.widthAnchor.constraint(equalToConstant: 45),
            numberOfVotesLabel.heightAnchor.constraint(equalToConstant: 25),
            chooseButton.centerYAnchor.constraint(equalTo: shopImageView.centerYAnchor),
            chooseButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            chooseButton.heightAnchor.constraint(equalToConstant: 40),
            chooseButton.widthAnchor.constraint(equalToConstant: 40)
        ])
    }
    func setupVoteCell(number: String, shopImageURL: String?, shopName: String, numberOfVote: Int?) {
        numberLabel.text = number
        shopImageView.loadImage(shopImageURL, placeHolder: UIImage(systemName: "bag")?.setColor(color: .darkBrown))
        shopNameLabel.text = shopName
        numberOfVotesLabel.text = String("\(numberOfVote ?? 0)票")
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension NotVotedCell {
    private func makeNumberLabel() -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.font = .title2()
        label.textColor = UIColor.white
        label.backgroundColor = .darkLogoBrown
        label.textAlignment = .center
        label.layer.cornerRadius = 14
        label.layer.masksToBounds = true
        return label
    }
    private func makeShopNameLabel() -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.font = .title3()
        label.textColor = UIColor.darkLogoBrown
        return label
    }
    private func makeImageView() -> UIImageView {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 10
        imageView.layer.masksToBounds = true
        imageView.alpha = 0.9
        return imageView
    }
    private func makeNumberOfVotesLabel() -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.font = .medium3()
        label.textColor = UIColor.middleBrown
        label.backgroundColor = UIColor.white
        label.layer.cornerRadius = 6
        label.layer.masksToBounds = true
        label.textAlignment = .center
        return label
    }
    private func makeChooseButton() -> UIButton {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
//        button.setTitleColor(UIColor.darkLogoBrown, for: .normal)
        button.titleLabel?.font = .regular(size: 14)
        button.setImage(UIImage(systemName: "circle")?.setColor(color: .darkLogoBrown), for: .normal)
        button.setImage(UIImage(systemName: "circle.inset.filled")?.setColor(color: .darkLogoBrown), for: .selected)
        button.addTarget(self, action: #selector(chooseButtonTapped(_:)), for: .touchUpInside)
        return button
    }
    private func makeViewMenuButton() -> UIButton {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(UIColor.middleBrown, for: .normal)
        button.titleLabel?.font = .regular5()
        button.setTitle("查看菜單 >", for: .normal)
        button.contentVerticalAlignment = .bottom
        button.addTarget(self, action: #selector(viewButtonTapped(_:)), for: .touchUpInside)
        return button
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
    @objc func chooseButtonTapped(_ sender: UIButton) {
        delegate?.didSelectedChooseButton(self, button: sender)
    }
    @objc func viewButtonTapped(_ sender: UIButton) {
        delegate?.didPressedViewMenuButton(self, button: sender)
    }
}
