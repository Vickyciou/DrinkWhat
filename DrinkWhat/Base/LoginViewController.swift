//
//  LoginViewController.swift
//  DrinkWhat
//
//  Created by Vickyciou on 2023/6/19.
//

import UIKit
import LineSDK
import AuthenticationServices
import CryptoKit
import FirebaseAuth

protocol LoginViewControllerDelegate: AnyObject {
    func loginViewControllerDismissSelf(_ viewController: LoginViewController)
}

class LoginViewController: UIViewController {
    private lazy var appIconImageView: UIImageView = makeAppIconImageView()
    private lazy var appNameLabel: UILabel = makeAppNameLabel()
    private lazy var signInWithAppleButton = ASAuthorizationAppleIDButton(type: .signIn, style: .black)
    private lazy var skipButton: UIButton = makeSkipButton()
    private var currentNonce: String?
    private let userManager = UserManager.shared
    weak var delegate: LoginViewControllerDelegate?

    init() {
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupVC()
    }
    private func setupVC() {
        view.backgroundColor = .white
        setupMainView()
    }

    private func setupMainView() {
        let contents = [appIconImageView, appNameLabel, signInWithAppleButton, skipButton]
        contents.forEach { view.addSubview($0) }
        NSLayoutConstraint.activate([
            appIconImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 150),
            appIconImageView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            appIconImageView.heightAnchor.constraint(equalToConstant: 150),
            appIconImageView.widthAnchor.constraint(equalToConstant: 150),
            appNameLabel.topAnchor.constraint(equalTo: appIconImageView.bottomAnchor, constant: 20),
            appNameLabel.centerXAnchor.constraint(equalTo: appIconImageView.centerXAnchor),
            signInWithAppleButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50),
            signInWithAppleButton.heightAnchor.constraint(equalToConstant: 50),
            signInWithAppleButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 32),
            signInWithAppleButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -32),
            skipButton.bottomAnchor.constraint(equalTo: signInWithAppleButton.topAnchor, constant: -20),
            skipButton.trailingAnchor.constraint(equalTo: signInWithAppleButton.trailingAnchor),
            skipButton.leadingAnchor.constraint(equalTo: signInWithAppleButton.leadingAnchor),
            skipButton.heightAnchor.constraint(equalTo: signInWithAppleButton.heightAnchor)
        ])

        signInWithAppleButton.translatesAutoresizingMaskIntoConstraints = false
        signInWithAppleButton.addTarget(self, action: #selector(startSignInWithAppleFlow), for: .touchUpInside)
    }

    @objc func startSignInWithAppleFlow() {
        Task {
            do {
                let helper = SignInWithAppleHelper(viewController: self)
                let tokens = try await helper.startSignInWithAppleFlow()
                let authDataResult = try await userManager.signInWithApple(tokens: tokens)
                let user = UserObject(auth: authDataResult)
                try await UserManager.shared.createUserData(userObject: user)
//                try await UserManager.shared.loadCurrentUser()
                delegate?.loginViewControllerDismissSelf(self)
            } catch {
                print("startSignInWithAppleFlow error \(error)")
            }
        }
    }
}
extension LoginViewController {
    private func makeAppIconImageView() -> UIImageView {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 75
        imageView.layer.masksToBounds = true
        imageView.image = UIImage(named: "AppIcon")
        return imageView
    }
    private func makeAppNameLabel() -> UILabel {
        let label = UILabel()
        let optimaBoldFont = UIFont(name: "Marker Felt Wide", size: 36)
        let attributes: [NSAttributedString.Key: Any] = [
            .font: optimaBoldFont,
            .foregroundColor: UIColor.white,
            .strokeColor: UIColor.logoBrown,
            .strokeWidth: -5.0
        ]
        label.attributedText = NSAttributedString(string: "Drink What", attributes: attributes)
        label.translatesAutoresizingMaskIntoConstraints = false

        return label
    }
    private func makeSkipButton() -> UIButton {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(.darkGray, for: .normal)
        button.titleLabel?.font = .medium2()
        button.setTitle("Visitor Entrance", for: .normal)
        button.backgroundColor = .white
        button.layer.borderColor = UIColor.darkGray.cgColor
        button.layer.borderWidth = 2
        button.layer.cornerRadius = 5
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(skipButtonTapped), for: .touchUpInside)
        return button
    }
    @objc func skipButtonTapped() {
        delegate?.loginViewControllerDismissSelf(self)
    }

}
