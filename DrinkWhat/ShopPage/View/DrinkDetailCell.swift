//
//  DrinkDetailCell.swift
//  DrinkWhat
//
//  Created by Vickyciou on 2023/6/27.
//

import UIKit

class DrinkDetailCell: UITableViewCell {
    private lazy var descriptionLabel: UILabel = makeDescriptionLabel()
    lazy var chooseButton: UIButton = makeChooseButton()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        let content = [descriptionLabel, chooseButton]
        content.forEach { contentView.addSubview($0) }
        NSLayoutConstraint.activate([
            descriptionLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            descriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            descriptionLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
            chooseButton.centerYAnchor.constraint(equalTo: descriptionLabel.centerYAnchor),
            chooseButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            chooseButton.heightAnchor.constraint(equalToConstant: 40),
            chooseButton.widthAnchor.constraint(equalToConstant: 40)
        ])
    }
    func setupCell(description: String) {
        descriptionLabel.text = description
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension DrinkDetailCell {
    private func makeDescriptionLabel() -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.font = .medium(size: 18)
        label.textColor = UIColor.darkBrown
        return label
    }
    private func makeChooseButton() -> UIButton {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(UIColor.midiumBrown, for: .normal)
        button.titleLabel?.font = .regular(size: 14)
        button.setImage(UIImage(systemName: "circle")?.setColor(color: .darkBrown), for: .normal)
        button.setImage(UIImage(systemName: "circle.inset.filled")?.setColor(color: .darkBrown), for: .selected)
        return button
    }

}
