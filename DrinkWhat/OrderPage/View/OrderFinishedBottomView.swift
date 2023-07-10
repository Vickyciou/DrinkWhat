//
//  OrderFinishedBottomView.swift
//  DrinkWhat
//
//  Created by Vickyciou on 2023/7/2.
//

import UIKit

class OrderFinishedBottomView: UIView {
    private lazy var borderView: UIView = makeBorderView()
    private lazy var label: UILabel = makeLabel()

    override init(frame: CGRect) {
        super.init(frame: frame)

        let contents = [borderView, label]
        contents.forEach { addSubview($0) }
        NSLayoutConstraint.activate([
            borderView.topAnchor.constraint(equalTo: topAnchor),
            borderView.heightAnchor.constraint(equalToConstant: 0.5),
            borderView.widthAnchor.constraint(equalTo: widthAnchor),
            label.topAnchor.constraint(equalTo: borderView.bottomAnchor, constant: 12),
            label.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12),
            label.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension OrderFinishedBottomView {
    private func makeBorderView() -> UIView {
        let borderView = UIView(frame: .zero)
        borderView.translatesAutoresizingMaskIntoConstraints = false
        borderView.backgroundColor = .lightBrown
        return borderView
    }

    private func makeLabel() -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.font = .medium3()
        label.textColor = UIColor.darkGray
        label.alpha = 0.9
        label.text = "此團購已結束"
        return label
    }
}
