//
//  CustomDrinkCell.swift
//  DrinkWhat
//
//  Created by Vickyciou on 2023/6/30.
//

import UIKit

class CustomDrinkCell: UITableViewCell {
    private lazy var drinkNameLabel: UILabel = makeDrinkNameLabel()
    private lazy var volumeLabel: UILabel = makeLabel()
    private lazy var iceLabel: UILabel = makeLabel()
    private lazy var sugarLabel: UILabel = makeLabel()
    private lazy var addToppingsLabel: UILabel = makeLabel()
    private lazy var noteLabel: UILabel = makeLabel()
    private lazy var priceLabel: UILabel = makePriceLabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        let content = [drinkNameLabel, volumeLabel, iceLabel, sugarLabel, addToppingsLabel, noteLabel, priceLabel]
        content.forEach { contentView.addSubview($0) }
        NSLayoutConstraint.activate([
            drinkNameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            drinkNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            drinkNameLabel.trailingAnchor.constraint(equalTo: priceLabel.leadingAnchor, constant: -8),
            volumeLabel.topAnchor.constraint(equalTo: drinkNameLabel.bottomAnchor, constant: 8),
            volumeLabel.leadingAnchor.constraint(equalTo: drinkNameLabel.leadingAnchor),
            volumeLabel.trailingAnchor.constraint(equalTo: drinkNameLabel.trailingAnchor),
            iceLabel.topAnchor.constraint(equalTo: volumeLabel.bottomAnchor, constant: 4),
            iceLabel.leadingAnchor.constraint(equalTo: drinkNameLabel.leadingAnchor),
            iceLabel.trailingAnchor.constraint(equalTo: drinkNameLabel.trailingAnchor),
            sugarLabel.topAnchor.constraint(equalTo: iceLabel.bottomAnchor, constant: 4),
            sugarLabel.leadingAnchor.constraint(equalTo: drinkNameLabel.leadingAnchor),
            sugarLabel.trailingAnchor.constraint(equalTo: drinkNameLabel.trailingAnchor),
            addToppingsLabel.topAnchor.constraint(equalTo: sugarLabel.bottomAnchor, constant: 4),
            addToppingsLabel.leadingAnchor.constraint(equalTo: drinkNameLabel.leadingAnchor),
            addToppingsLabel.trailingAnchor.constraint(equalTo: drinkNameLabel.trailingAnchor),
            noteLabel.topAnchor.constraint(equalTo: addToppingsLabel.bottomAnchor, constant: 4),
            noteLabel.leadingAnchor.constraint(equalTo: drinkNameLabel.leadingAnchor),
            noteLabel.trailingAnchor.constraint(equalTo: drinkNameLabel.trailingAnchor),
            noteLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            priceLabel.topAnchor.constraint(equalTo: drinkNameLabel.topAnchor),
            priceLabel.widthAnchor.constraint(equalToConstant: 60),
            priceLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20)
        ])
    }
    func setupCell(drinkName: String,
                   volume: String,
                   ice: String,
                   sugar: String,
                   addToppings: [String],
                   note: String,
                   price: Int) {
        let addToppingsString = addToppings.joined(separator: ", ")
        drinkNameLabel.text = drinkName
        volumeLabel.text = "份量：\(volume)"
        iceLabel.text = "冰量：\(ice)"
        sugarLabel.text = "甜度：\(sugar)"
        addToppingsLabel.text = "加料：\(addToppingsString)"
        noteLabel.text = "備註：\(note)"
        priceLabel.text = "$ \(price)"

    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
extension CustomDrinkCell {
    private func makeDrinkNameLabel() -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.font = .medium2()
        label.textColor = UIColor.middleDarkBrown
        return label
    }
    private func makeLabel() -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.font = .regular4()
        label.textColor = UIColor.logoBrown
        return label
    }
    private func makePriceLabel() -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .right
        label.numberOfLines = 0
        label.font = .medium3()
        label.textColor = UIColor.darkLogoBrown
        return label
    }
}
