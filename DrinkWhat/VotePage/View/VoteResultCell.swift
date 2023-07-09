//
//  VoteResultCell.swift
//  DrinkWhat
//
//  Created by Vickyciou on 2023/6/18.
//

import UIKit

class VoteResultCell: UITableViewCell {
    private lazy var shopNameLabel: UILabel = makeShopNameLabel()
    private lazy var numberOfVotesLabel: UILabel = makeNumberOfVotesLabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        self.selectionStyle = .none
        let content = [shopNameLabel, numberOfVotesLabel]
        content.forEach { contentView.addSubview($0) }
        NSLayoutConstraint.activate([

            shopNameLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            shopNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            shopNameLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            numberOfVotesLabel.centerYAnchor.constraint(equalTo: shopNameLabel.centerYAnchor),
            numberOfVotesLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            numberOfVotesLabel.widthAnchor.constraint(equalToConstant: 45),
            numberOfVotesLabel.heightAnchor.constraint(equalToConstant: 25)
        ])
    }
    func setupVoteCell(shopName: String, numberOfVote: Int?) {
        shopNameLabel.text = shopName
        numberOfVotesLabel.text = String("\(numberOfVote ?? 0)票")
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension VoteResultCell {
    private func makeShopNameLabel() -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.font = .regular2()
        label.textColor = UIColor.logoBrown
        return label
    }

    private func makeNumberOfVotesLabel() -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.font = .regular4()
        label.textColor = UIColor.logoBrown
        label.backgroundColor = UIColor.white
        label.layer.borderWidth = 1
        label.layer.borderColor = UIColor.logoBrown.cgColor
        label.layer.cornerRadius = 6
        label.layer.masksToBounds = true
        label.textAlignment = .center
        return label
    }
}
