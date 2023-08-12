//
//  OrderTableViewFooter.swift
//  DrinkWhat
//
//  Created by Vickyciou on 2023/7/2.
//

import UIKit

protocol OrderTableViewFooterDelegate: AnyObject {
    func exitButtonTapped(_ view: OrderTableViewFooter)
}

class OrderTableViewFooter: UIView {
    private lazy var imageView: UIImageView = makeImageView()
    private lazy var amountLabel: UILabel = makeLabel()
    private lazy var stackView: UIStackView = makeStackView()
    private lazy var exitButton: UIButton = makeExitButton()
    weak var delegate: OrderTableViewFooterDelegate?

    override init(frame: CGRect) {
        super.init(frame: frame)

        let contents = [stackView, exitButton]
        contents.forEach { self.addSubview($0) }


        NSLayoutConstraint.activate([
            imageView.heightAnchor.constraint(equalToConstant: 25),
            imageView.widthAnchor.constraint(equalToConstant: 25),
            stackView.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            stackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            exitButton.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 16),
            exitButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            exitButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8)
        ])
    }
    func setupView(amount: Int, exitButtonIsHidden: Bool) {
        amountLabel.text = "總計$ \(amount)"
        exitButton.isHidden = exitButtonIsHidden
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
extension OrderTableViewFooter {
    private func makeImageView() -> UIImageView {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "orderBig")?.setColor(color: .darkLogoBrown)
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }

    private func makeLabel() -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.font = .title3()
        label.textColor = UIColor.darkLogoBrown
        return label
    }
    private func makeExitButton() -> UIButton {
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(UIColor.red, for: .normal)
        button.setTitleColor(UIColor.red.withAlphaComponent(0.5), for: .highlighted)
        button.titleLabel?.font = .regular3()
        button.setTitle("離開此團購", for: .normal)
        button.layer.cornerRadius = 5
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(exitButtonTapped), for: .touchUpInside)
        return button
    }
    @objc func exitButtonTapped() {
        delegate?.exitButtonTapped(self)
    }

    private func makeStackView() -> UIStackView {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.addArrangedSubview(imageView)
        stackView.addArrangedSubview(amountLabel)
        stackView.axis = .horizontal
        stackView.spacing = 12
        stackView.alignment = .center
        stackView.distribution = .fill
        return stackView
    }
}
