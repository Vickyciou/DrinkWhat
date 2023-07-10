//
//  InitiatorOrderingBottomView.swift
//  DrinkWhat
//
//  Created by Vickyciou on 2023/7/2.
//

import UIKit

protocol InitiatorOrderingBottomViewDelegate: AnyObject {
    func cancelButtonTapped(_ view: InitiatorOrderingBottomView)
    func finishButtonTapped(_ view: InitiatorOrderingBottomView)
}

class InitiatorOrderingBottomView: UIView {
    private lazy var borderView: UIView = makeBorderView()
    private lazy var cancelButton: UIButton = makeCancelButton()
    private lazy var finishButton: UIButton = makeFinishButton()
    weak var delegate: InitiatorOrderingBottomViewDelegate?

    override init(frame: CGRect) {
        super.init(frame: frame)

        let contents = [borderView, cancelButton, finishButton]
        contents.forEach { addSubview($0) }
        NSLayoutConstraint.activate([
            borderView.topAnchor.constraint(equalTo: topAnchor),
            borderView.heightAnchor.constraint(equalToConstant: 0.5),
            borderView.widthAnchor.constraint(equalTo: widthAnchor),
            cancelButton.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            cancelButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            cancelButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            cancelButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            cancelButton.heightAnchor.constraint(equalToConstant: 44),
            finishButton.topAnchor.constraint(equalTo: cancelButton.bottomAnchor, constant: 8),
            finishButton.centerXAnchor.constraint(equalTo: cancelButton.centerXAnchor),
            finishButton.widthAnchor.constraint(equalTo: cancelButton.widthAnchor),
            finishButton.heightAnchor.constraint(equalTo: cancelButton.heightAnchor),
            finishButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -4)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension InitiatorOrderingBottomView {
    private func makeBorderView() -> UIView {
        let borderView = UIView(frame: .zero)
        borderView.translatesAutoresizingMaskIntoConstraints = false
        borderView.backgroundColor = .lightBrown
        return borderView
    }
    private func makeCancelButton() -> UIButton {
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(UIColor.darkLogoBrown, for: .normal)
        button.titleLabel?.font = .medium(size: 16)
        let normalBackground = UIColor.lightBrown.toImage()
        let highlightedBackground = UIColor.middleBrown.toImage()
        button.setBackgroundImage(normalBackground, for: .normal)
        button.setBackgroundImage(highlightedBackground, for: .highlighted)
        button.setTitle("取消訂單", for: .normal)
        button.layer.cornerRadius = 5
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
        return button
    }
    @objc func cancelButtonTapped() {
        delegate?.cancelButtonTapped(self)
    }
    private func makeFinishButton() -> UIButton {
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(UIColor.lightGrayYellow, for: .normal)
        button.setTitleColor(UIColor.lightBrown, for: .highlighted)
        button.titleLabel?.font = .medium(size: 16)
        let normalBackground = UIColor.darkGray.toImage()
        let highlightedBackground = UIColor.darkBrown.toImage()
        button.setBackgroundImage(normalBackground, for: .normal)
        button.setBackgroundImage(highlightedBackground, for: .highlighted)
        button.setTitle("完成訂單", for: .normal)
        button.layer.cornerRadius = 5
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(finishButtonTapped), for: .touchUpInside)
        return button
    }
    @objc func finishButtonTapped() {
        delegate?.finishButtonTapped(self)
    }
}
