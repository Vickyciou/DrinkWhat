//
//  VoteCell.swift
//  DrinkWhat
//
//  Created by Vickyciou on 2023/6/15.
//

import UIKit

class VoteCell: UITableViewCell {
    private lazy var userNameLabel: UILabel = makeUserNameLabel()
    private lazy var voteStateLabel: UILabel = makeVoteStateLabel()
    private lazy var profileImageView: UIImageView = makeProfileImageView()
    private lazy var arrowImageView: UIImageView = makeArrowImageView()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        let content = [userNameLabel, voteStateLabel, profileImageView, arrowImageView]
        content.forEach { contentView.addSubview($0) }
        NSLayoutConstraint.activate([
            profileImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            profileImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            profileImageView.heightAnchor.constraint(equalToConstant: 60),
            profileImageView.widthAnchor.constraint(equalToConstant: 60),
            profileImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            userNameLabel.topAnchor.constraint(equalTo: profileImageView.topAnchor, constant: 8),
            userNameLabel.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 8),
            voteStateLabel.topAnchor.constraint(equalTo: userNameLabel.bottomAnchor, constant: 2),
            voteStateLabel.leadingAnchor.constraint(equalTo: userNameLabel.leadingAnchor),
            arrowImageView.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor),
            arrowImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            arrowImageView.heightAnchor.constraint(equalToConstant: 15),
            arrowImageView.widthAnchor.constraint(equalToConstant: 15)
        ])
    }
    func setupVoteCell(profileImage: UIImage?, userName: String, voteState: String) {
        profileImageView.image = profileImage
        userNameLabel.text = userName
        voteStateLabel.text = voteState
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension VoteCell {
    private func makeUserNameLabel() -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.font = .medium(size: 18)
        label.textColor = UIColor.darkBrown
        return label
    }
    private func makeVoteStateLabel() -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.font = .regular(size: 14)
        label.textColor = UIColor.lightBrown
        return label
    }
    private func makeProfileImageView() -> UIImageView {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 30
        return imageView
    }
    private func makeArrowImageView() -> UIImageView {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(systemName: "arrow.right")
        return imageView
    }
}
