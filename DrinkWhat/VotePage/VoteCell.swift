//
//  VoteCell.swift
//  DrinkWhat
//
//  Created by Vickyciou on 2023/6/15.
//

import UIKit

class VoteCell: UITableViewCell {
    private lazy var shopNameLabel: UILabel = makeLabel()
    private lazy var voteStateLabel: UILabel = makeLabel()
    private lazy var profileImageView: UIImageView = makeImageView()
    private lazy var arrowImageView: UIImageView = makeImageView()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        let content = [shopNameLabel, voteStateLabel, profileImageView, arrowImageView]
        content.forEach { contentView.addSubview($0) }
        NSLayoutConstraint.activate([
            profileImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            profileImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            profileImageView.heightAnchor.constraint(equalToConstant: 60),
            profileImageView.widthAnchor.constraint(equalToConstant: 60),
            profileImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            shopNameLabel.topAnchor.constraint(equalTo: profileImageView.topAnchor, constant: 8),
            shopNameLabel.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 8),
            voteStateLabel.topAnchor.constraint(equalTo: shopNameLabel.bottomAnchor, constant: 2),
            voteStateLabel.leadingAnchor.constraint(equalTo: shopNameLabel.leadingAnchor),
            arrowImageView.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor),
            arrowImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            arrowImageView.heightAnchor.constraint(equalToConstant: 15),
            arrowImageView.widthAnchor.constraint(equalToConstant: 15)
        ])
    }
    func setupVoteCell(profileImage: UIImage?, shopName: String, voteState: String) {
        profileImageView.image = profileImage
        shopNameLabel.text = shopName
        voteStateLabel.text = voteState
        arrowImageView.image = UIImage(systemName: "arrow.right")
        profileImageView.layer.cornerRadius = 30
        shopNameLabel.font = .medium(size: 18)
        voteStateLabel.font = .regular(size: 14)
        shopNameLabel.textColor = .darkGray
        voteStateLabel.textColor = .lightGray
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension VoteCell {
    private func makeLabel() -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }
    private func makeImageView() -> UIImageView {
        let profileImageView = UIImageView()
        profileImageView.contentMode = .scaleAspectFill
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        return profileImageView
    }
}
