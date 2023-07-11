//
//  DrinkDetailTableViewFooter.swift
//  DrinkWhat
//
//  Created by Vickyciou on 2023/7/10.
//

import UIKit

protocol DrinkDetailTableViewFooterDelegate: AnyObject {
    func textFieldEndEditing(_ view: DrinkDetailTableViewFooter, text: String)
}

class DrinkDetailTableViewFooter: UIView, UITextFieldDelegate {
    private lazy var label: UILabel = makeLabel()
    private lazy var textField: UITextField = makeTextField()
    weak var delegate: DrinkDetailTableViewFooterDelegate?

    override init(frame: CGRect) {
        super.init(frame: frame)

        let contents = [label, textField]
        contents.forEach { self.addSubview($0) }

        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            textField.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 8),
            textField.leadingAnchor.constraint(equalTo: label.leadingAnchor),
            textField.trailingAnchor.constraint(equalTo: label.trailingAnchor),
            textField.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
extension DrinkDetailTableViewFooter {
    private func makeLabel() -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.font = .medium3()
        label.textColor = UIColor.darkBrown
        label.text = "備註欄"
        return label
    }

    private func makeTextField() -> UITextField {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.delegate = self
        textField.textColor = .darkLogoBrown
        textField.borderStyle = .roundedRect
        textField.layer.borderColor = UIColor.darkLogoBrown.cgColor
        textField.font = .regular3()
        return textField
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let text = textField.text else { return }
        delegate?.textFieldEndEditing(self, text: text)
    }

}
