//
//  JoinUsersBottomView.swift
//  DrinkWhat
//
//  Created by Vickyciou on 2023/7/2.
//

import UIKit

protocol JoinUsersBottomViewDelegate: AnyObject {
    func linePayButtonTapped(_ view: JoinUsersBottomView)
    func addItemButtonTapped(_ view: JoinUsersBottomView)
}

class JoinUsersBottomView: UIView {
    private lazy var borderView: UIView = makeBorderView()
    private lazy var linePayButton: UIButton = makeLinePayButton()
    private lazy var addItemButton: UIButton = makeAddItemButton()
    weak var delegate: JoinUsersBottomViewDelegate?

    override init(frame: CGRect) {
        super.init(frame: frame)

        let contents = [borderView, linePayButton, addItemButton]
        contents.forEach { addSubview($0) }
        NSLayoutConstraint.activate([
            borderView.topAnchor.constraint(equalTo: topAnchor),
            borderView.heightAnchor.constraint(equalToConstant: 0.5),
            borderView.widthAnchor.constraint(equalTo: widthAnchor),
            linePayButton.topAnchor.constraint(equalTo: topAnchor, constant: 4),
            linePayButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            linePayButton.widthAnchor.constraint(equalToConstant: 250),
            linePayButton.heightAnchor.constraint(equalToConstant: 30),
            addItemButton.topAnchor.constraint(equalTo: linePayButton.bottomAnchor, constant: 8),
            addItemButton.centerXAnchor.constraint(equalTo: linePayButton.centerXAnchor),
            addItemButton.widthAnchor.constraint(equalTo: linePayButton.widthAnchor),
            addItemButton.heightAnchor.constraint(equalTo: linePayButton.heightAnchor),
            addItemButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -4)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension JoinUsersBottomView {
    private func makeBorderView() -> UIView {
        let borderView = UIView(frame: .zero)
        borderView.translatesAutoresizingMaskIntoConstraints = false
        borderView.backgroundColor = .lightBrown
        return borderView
    }


    private func makeAddItemButton() -> UIButton {
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(UIColor.skinColor, for: .normal)
        button.setTitleColor(UIColor.lightBrown, for: .highlighted)
        button.titleLabel?.font = .medium(size: 16)
        let normalBackground = UIColor.darkGray.toImage(size: CGSize(width: 65, height: 25))
        let highlightedBackground = UIColor.darkBrown.toImage(size: CGSize(width: 65, height: 25))
        button.setBackgroundImage(normalBackground, for: .normal)
        button.setBackgroundImage(highlightedBackground, for: .highlighted)
        button.setTitle("新增品項", for: .normal)
        button.layer.cornerRadius = 5
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(addItemButtonTapped), for: .touchUpInside)
        return button
    }
    @objc func addItemButtonTapped() {
        delegate?.addItemButtonTapped(self)
    }
    private func makeLinePayButton() -> UIButton {
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(UIColor.darkBrown, for: .normal)
        button.setTitleColor(UIColor.skinColor, for: .highlighted)
        button.titleLabel?.font = .medium(size: 16)
        let normalBackground = UIColor.lightBrown.toImage(size: CGSize(width: 65, height: 25))
        let highlightedBackground = UIColor.midiumBrown.toImage(size: CGSize(width: 65, height: 25))
        button.setBackgroundImage(normalBackground, for: .normal)
        button.setBackgroundImage(highlightedBackground, for: .highlighted)
        button.setTitle("Line Pay 付款去", for: .normal)
        button.layer.cornerRadius = 5
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(linePayButtonTapped), for: .touchUpInside)
        return button
    }
    @objc func linePayButtonTapped() {
        delegate?.linePayButtonTapped(self)
    }
}