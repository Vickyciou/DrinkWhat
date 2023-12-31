//
//  DrinkDetailCell.swift
//  DrinkWhat
//
//  Created by Vickyciou on 2023/6/27.
//

import UIKit

class DrinkDetailCell: UITableViewCell {
    private lazy var descriptionLabel: UILabel = makeDescriptionLabel()
    private lazy var addPriceLabel: UILabel = makePriceLabel()
    lazy var chooseButton: UIButton = makeChooseButton()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        let content = [descriptionLabel, addPriceLabel, chooseButton]
        content.forEach { contentView.addSubview($0) }
        NSLayoutConstraint.activate([
            descriptionLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            descriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            descriptionLabel.trailingAnchor.constraint(equalTo: chooseButton.leadingAnchor, constant: -4),
            addPriceLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 2),
            addPriceLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
            addPriceLabel.leadingAnchor.constraint(equalTo: descriptionLabel.leadingAnchor, constant: 4),
            addPriceLabel.trailingAnchor.constraint(equalTo: descriptionLabel.trailingAnchor),
            chooseButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            chooseButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            chooseButton.heightAnchor.constraint(equalToConstant: 25),
            chooseButton.widthAnchor.constraint(equalToConstant: 25)
        ])
    }
    func setupCell(description: String, isSelected: Bool) {
        descriptionLabel.text = description
        addPriceLabel.text = nil
        chooseButton.isSelected = isSelected
    }
    func setupAddToppingCell(description: String, addPrice: Int, isSelected: Bool) {
        descriptionLabel.text = description
        addPriceLabel.text = "+ $ \(addPrice)"
        chooseButton.isSelected = isSelected
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
        label.font = .regular3()
        label.textColor = UIColor.darkLogoBrown
        return label
    }
    private func makePriceLabel() -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.font = .regular4()
        label.textColor = UIColor.logoBrown
        return label
    }
    private func makeChooseButton() -> UIButton {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isUserInteractionEnabled = false
        button.setTitleColor(UIColor.middleBrown, for: .normal)
        button.titleLabel?.font = .regular4()
        button.setImage(UIImage(systemName: "circle")?.setColor(color: .darkLogoBrown), for: .normal)
        button.setImage(UIImage(systemName: "circle.inset.filled")?.setColor(color: .darkLogoBrown), for: .selected)
        return button
    }
}
