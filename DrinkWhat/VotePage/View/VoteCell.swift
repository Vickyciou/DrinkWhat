//
//  VoteCell.swift
//  DrinkWhat
//
//  Created by Vickyciou on 2023/6/15.
//

import UIKit

class VoteCell: UITableViewCell {
    private lazy var userNameLabel: UILabel = makeUserNameLabel()
    private lazy var voteStateLabel: UILabel = makeLabel()
    private lazy var dateLabel: UILabel = makeLabel()
    private lazy var profileImageView: UIImageView = makeProfileImageView()
    private lazy var arrowImageView: UIImageView = makeArrowImageView()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        let content = [userNameLabel, voteStateLabel, dateLabel, profileImageView, arrowImageView]
        content.forEach { contentView.addSubview($0) }
        NSLayoutConstraint.activate([
            profileImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            profileImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            profileImageView.heightAnchor.constraint(equalToConstant: 60),
            profileImageView.widthAnchor.constraint(equalToConstant: 60),
            profileImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            userNameLabel.topAnchor.constraint(equalTo: profileImageView.topAnchor, constant: 8),
            userNameLabel.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 8),
            dateLabel.topAnchor.constraint(equalTo: userNameLabel.bottomAnchor, constant: 2),
            dateLabel.leadingAnchor.constraint(equalTo: userNameLabel.leadingAnchor),
            voteStateLabel.topAnchor.constraint(equalTo: dateLabel.topAnchor),
            voteStateLabel.leadingAnchor.constraint(equalTo: dateLabel.trailingAnchor, constant: 4),
            arrowImageView.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor),
            arrowImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            arrowImageView.heightAnchor.constraint(equalToConstant: 15),
            arrowImageView.widthAnchor.constraint(equalToConstant: 15)
        ])
    }
    func setupVoteCell(profileImage: UIImage?, userName: String, voteState: String, date: String) {
        profileImageView.image = profileImage
        userNameLabel.text = userName
        voteStateLabel.text = voteState
        dateLabel.text = date
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
    private func makeLabel() -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.font = .regular(size: 14)
        label.textColor = UIColor.midiumBrown
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
        imageView.image = UIImage(systemName: "arrow.right")?.setColor(color: .darkBrown)
        return imageView
    }
}
