//
//  OrderSectionHeaderView.swift
//  DrinkWhat
//
//  Created by Vickyciou on 2023/7/1.
//

import UIKit

protocol OrderSectionHeaderViewDelegate: AnyObject {
    func didPressedPaidStatusButton(_ view: OrderSectionHeaderView)
}

class OrderSectionHeaderView: UIView {
    private lazy var userImageView: UIImageView = makeImageView()
    private lazy var userNameLabel: UILabel = makeUserNameLabel()
    private lazy var paidStatusButton: UIButton = makePaidStatusButton()
    weak var delegate: OrderSectionHeaderViewDelegate?

    override init(frame: CGRect) {
        super.init(frame: frame)

        let contents = [userImageView, userNameLabel, paidStatusButton]
        contents.forEach { self.addSubview($0) }

        NSLayoutConstraint.activate([
            userImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 4),
            userImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            userImageView.heightAnchor.constraint(equalToConstant: 50),
            userImageView.widthAnchor.constraint(equalToConstant: 50),
            userImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -4),
            userNameLabel.centerYAnchor.constraint(equalTo: userImageView.centerYAnchor),
            userNameLabel.leadingAnchor.constraint(equalTo: userImageView.trailingAnchor, constant: 16),
            paidStatusButton.centerYAnchor.constraint(equalTo: userImageView.centerYAnchor),
            paidStatusButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20)
        ])
    }

    func setupView(userImageURL: String?, userName: String, isPaid: Bool) {
        userImageView.loadImage(userImageURL,
                                placeHolder: UIImage(systemName: "person.circle.fill")?.setColor(color: .darkBrown))
        userNameLabel.text = userName
        paidStatusButton.isEnabled = !isPaid
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
extension OrderSectionHeaderView {
    private func makeImageView() -> UIImageView {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 25
        imageView.layer.masksToBounds = true
        return imageView
    }
    private func makeUserNameLabel() -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.font = .bold(size: 22)
        label.textColor = UIColor.darkBrown
        return label
    }
    private func makePaidStatusButton() -> UIButton {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(UIColor.skinColor, for: .disabled)
        button.setTitleColor(UIColor.darkBrown, for: .normal)
        button.titleLabel?.font = .medium(size: 16)
        let normalBackground = UIColor.darkBrown.toImage(size: CGSize(width: 65, height: 25))
        let selectedBackground = UIColor.white.toImage(size: CGSize(width: 65, height: 25))
        button.setBackgroundImage(normalBackground, for: .disabled)
        button.setBackgroundImage(selectedBackground, for: .normal)
        button.layer.borderColor = UIColor.darkBrown.cgColor
        button.layer.borderWidth = 1
        button.setTitle("未付款", for: .normal)
        button.setTitle("已付款", for: .disabled)
        button.layer.cornerRadius = 5
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(paidStatusButtonTapped), for: .touchUpInside)
        return button
    }
    @objc func paidStatusButtonTapped() {
        delegate?.didPressedPaidStatusButton(self)
    }

}
