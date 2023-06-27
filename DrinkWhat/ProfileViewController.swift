//
//  ProfileViewController.swift
//  DrinkWhat
//
//  Created by Vickyciou on 2023/6/15.
//

import UIKit

class ProfileViewController: UIViewController {
    private lazy var logOutButton: UIButton = makeLogOutButton()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupVC()
    }

    private func setupVC() {
        setupLogOUtButton()
    }

    private func setupLogOUtButton() {
        view.addSubview(logOutButton)
        NSLayoutConstraint.activate([
            logOutButton.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
            logOutButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor)])
    }
}
extension ProfileViewController {
    private func makeLogOutButton() -> UIButton {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(UIColor.darkBrown, for: .normal)
        button.setTitleColor(UIColor.skinColor, for: .highlighted)
        button.titleLabel?.font = .regular(size: 18)
        button.backgroundColor = .logoBrown
        button.setTitle("Log out", for: .normal)
        button.addTarget(self, action: #selector(logOutButtonTapped), for: .touchUpInside)
        return button
    }
    @objc func logOutButtonTapped() throws {
        try AuthManager.shared.signOut()
        show(RootViewController(), sender: nil)
    }
}
