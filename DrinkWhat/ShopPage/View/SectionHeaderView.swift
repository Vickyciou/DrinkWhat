//
//  SectionHeaderView.swift
//  DrinkWhat
//
//  Created by Vickyciou on 2023/6/23.
//

import UIKit

protocol SectionHeaderViewDelegate: AnyObject {
    func didPressAddOrderButton(_ view: SectionHeaderView)
    func didPressAddVoteButton(_ view: SectionHeaderView)
    func didPressAddFavoriteButton(_ view: SectionHeaderView)
}

class SectionHeaderView: UIView {
    private lazy var shopNameLabel: UILabel = makeShopNameLabel()
    private lazy var addOrderButton: UIButton = makeAddOrderButton()
    private lazy var addVoteButton: UIButton = makeAddVoteButton()
    private lazy var addFavoriteButton: UIButton = makeAddFavoriteButton()
    private lazy var stackView: UIStackView = makeStackView()
    weak var delegate: SectionHeaderViewDelegate?

    override init(frame: CGRect) {
        super.init(frame: frame)

        self.backgroundColor = .white
        let content = [shopNameLabel, stackView]
        content.forEach { self.addSubview($0) }
        NSLayoutConstraint.activate([
            shopNameLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 16),
            shopNameLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            shopNameLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            stackView.topAnchor.constraint(equalTo: shopNameLabel.bottomAnchor, constant: 12),
            stackView.leadingAnchor.constraint(equalTo: shopNameLabel.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: shopNameLabel.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -16)
        ])
    }
    func setupView(shopName: String) {
        shopNameLabel.text = shopName
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension SectionHeaderView {
    private func makeShopNameLabel() -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.font = .bold(size: 24)
        label.textColor = UIColor.darkBrown
        return label
    }
    private func makeAddOrderButton() -> UIButton {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 10
        button.layer.masksToBounds = true
        button.backgroundColor = .lightBrown
        button.setTitleColor(.darkBrown, for: .normal)
        button.setTitleColor(.skinColor, for: .highlighted)
        button.titleLabel?.font = .regular(size: 14)
        button.setTitle("+ 團購訂單", for: .normal)
        button.addTarget(self, action: #selector(addOrderButtonTapped(_:)), for: .touchUpInside)
        return button
    }
    private func makeAddVoteButton() -> UIButton {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 10
        button.layer.masksToBounds = true
        button.backgroundColor = .lightBrown
        button.setTitleColor(.darkBrown, for: .normal)
        button.setTitleColor(.skinColor, for: .highlighted)
        button.titleLabel?.font = .regular(size: 14)
        button.setTitle("+ 投票清單", for: .normal)
        button.addTarget(self, action: #selector(addVoteButtonTapped(_:)), for: .touchUpInside)
        return button
    }
    private func makeAddFavoriteButton() -> UIButton {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 10
        button.layer.masksToBounds = true
        button.backgroundColor = .lightBrown
        button.setTitleColor(.darkBrown, for: .normal)
        button.setTitleColor(.skinColor, for: .highlighted)
        button.titleLabel?.font = .regular(size: 14)
        button.setTitle("+ 收藏清單", for: .normal)
        button.addTarget(self, action: #selector(addFavoriteButtonTapped(_:)), for: .touchUpInside)
        return button
    }
    private func makeStackView() -> UIStackView {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.addArrangedSubview(addOrderButton)
        stackView.addArrangedSubview(addVoteButton)
        stackView.addArrangedSubview(addFavoriteButton)
        stackView.axis = .horizontal
        stackView.spacing = 10
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        return stackView
    }
    @objc func addOrderButtonTapped(_ sender: UIButton) {
        delegate?.didPressAddOrderButton(self)
    }
    @objc func addVoteButtonTapped(_ sender: UIButton) {
        delegate?.didPressAddVoteButton(self)
    }
    @objc func addFavoriteButtonTapped(_ sender: UIButton) {
        delegate?.didPressAddFavoriteButton(self)
    }
}
