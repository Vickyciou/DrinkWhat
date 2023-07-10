//
//  OrderSectionHeaderView.swift
//  DrinkWhat
//
//  Created by Vickyciou on 2023/7/1.
//

import UIKit

protocol OrderSectionHeaderViewDelegate: AnyObject {
    func didPressedPaidStatusButton(_ view: OrderSectionHeaderView, indexOfSection: Int)
}

class OrderSectionHeaderView: UIView {
    private lazy var userImageView: UIImageView = makeImageView()
    private lazy var userNameLabel: UILabel = makeUserNameLabel()
    private lazy var paidStatusButton: UIButton = makePaidStatusButton()
    private var indexOfSection: Int = 0
    weak var delegate: OrderSectionHeaderViewDelegate?

    override init(frame: CGRect) {
        super.init(frame: frame)

        let contents = [userImageView, userNameLabel, paidStatusButton]
        contents.forEach { self.addSubview($0) }

        NSLayoutConstraint.activate([
            userImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 12),
            userImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            userImageView.heightAnchor.constraint(equalToConstant: 50),
            userImageView.widthAnchor.constraint(equalToConstant: 50),
            userImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -4),
            userNameLabel.centerYAnchor.constraint(equalTo: userImageView.centerYAnchor),
            userNameLabel.leadingAnchor.constraint(equalTo: userImageView.trailingAnchor, constant: 16),
            paidStatusButton.centerYAnchor.constraint(equalTo: userImageView.centerYAnchor),
            paidStatusButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
            paidStatusButton.heightAnchor.constraint(equalToConstant: 30),
            paidStatusButton.widthAnchor.constraint(equalToConstant: 65)
        ])
    }

    func setupView(userImageURL: String?, userName: String, isPaid: Bool, indexOfSection: Int) {
        userImageView.loadImage(userImageURL,
                                placeHolder: UIImage(systemName: "person.circle.fill")?.setColor(color: .darkLogoBrown))
        userNameLabel.text = userName
        paidStatusButton.isEnabled = !isPaid
        self.indexOfSection = indexOfSection

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
        label.font = .title2()
        label.textColor = UIColor.middleDarkBrown
        return label
    }
    private func makePaidStatusButton() -> UIButton {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(UIColor.middleBrown, for: .disabled)
        button.setTitleColor(UIColor.darkLogoBrown, for: .normal)
        button.titleLabel?.font = .medium4()
        let selectedBackground = UIColor.lightGrayBrown.toImage()
        let normalBackground = UIColor.white.toImage()
        button.setBackgroundImage(selectedBackground, for: .disabled)
        button.setBackgroundImage(normalBackground, for: .normal)
        button.layer.borderColor = UIColor.lightGrayBrown.cgColor
        button.layer.borderWidth = 1
        button.setTitle("未付款", for: .normal)
        button.setTitle("已付款", for: .disabled)
        button.layer.cornerRadius = 5
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(paidStatusButtonTapped(_:)), for: .touchUpInside)
        return button
    }
    @objc func paidStatusButtonTapped(_ sender: UIButton) {
        delegate?.didPressedPaidStatusButton(self, indexOfSection: indexOfSection)
    }

}
