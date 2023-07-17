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
    private lazy var view: UIView = makeBackgroundView()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        contentView.addSubview(view)
        let content = [userNameLabel, voteStateLabel, dateLabel, profileImageView, arrowImageView]

        content.forEach { view.addSubview($0) }
        NSLayoutConstraint.activate([
            view.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            view.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            view.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            view.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            profileImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 12),
            profileImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            profileImageView.heightAnchor.constraint(equalToConstant: 50),
            profileImageView.widthAnchor.constraint(equalToConstant: 50),
            profileImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -12),
            userNameLabel.topAnchor.constraint(equalTo: profileImageView.topAnchor, constant: 4),
            userNameLabel.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 16),
            dateLabel.topAnchor.constraint(equalTo: userNameLabel.bottomAnchor, constant: 2),
            dateLabel.leadingAnchor.constraint(equalTo: userNameLabel.leadingAnchor),
            voteStateLabel.topAnchor.constraint(equalTo: dateLabel.topAnchor),
            voteStateLabel.leadingAnchor.constraint(equalTo: dateLabel.trailingAnchor, constant: 4),
            arrowImageView.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor),
            arrowImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            arrowImageView.heightAnchor.constraint(equalToConstant: 15),
            arrowImageView.widthAnchor.constraint(equalToConstant: 15)
        ])

    }
    func setupVoteCell(profileImageURL: String?, userName: String, voteState: String, date: String) {
        profileImageView.loadImage(profileImageURL, placeHolder: UIImage(systemName: "person.circle.fill")?
            .setColor(color: .middleDarkBrown))
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
    private func makeProfileImageView() -> UIImageView {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 25
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
