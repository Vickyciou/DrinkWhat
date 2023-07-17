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

protocol LoginSheetViewControllerDelegate: AnyObject {
    func loginSheetViewControllerLoginSuccess(_ viewController: LoginSheetViewController, withUser userObject: UserObject)
}

class LoginSheetViewController: UIViewController {
    private lazy var signInWithAppleButton = ASAuthorizationAppleIDButton(type: .signIn, style: .black)
    private lazy var remindLabel: UILabel = makeRemindLabel()
    private lazy var descriptionLabel: UILabel = makeDescriptionLabel()
    private lazy var appIconImageView: UIImageView = makeAppIconImageView()
    private lazy var closeButton: UIButton = makeCloseButton()
    private var currentNonce: String?
    private let userManager = UserManager.shared
    weak var delegate: LoginSheetViewControllerDelegate?

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
        let contents = [remindLabel, descriptionLabel, closeButton, appIconImageView, signInWithAppleButton]
        contents.forEach { view.addSubview($0) }
        signInWithAppleButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            remindLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            remindLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            remindLabel.trailingAnchor.constraint(equalTo: closeButton.leadingAnchor, constant: -16),
            descriptionLabel.topAnchor.constraint(equalTo: remindLabel.bottomAnchor, constant: 24),
            descriptionLabel.leadingAnchor.constraint(equalTo: remindLabel.leadingAnchor),
            closeButton.topAnchor.constraint(equalTo: remindLabel.topAnchor),
            closeButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            appIconImageView.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 60),
            appIconImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            appIconImageView.heightAnchor.constraint(equalToConstant: 100),
            appIconImageView.widthAnchor.constraint(equalTo: appIconImageView.heightAnchor),
            signInWithAppleButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -40),
            signInWithAppleButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16.0),
            signInWithAppleButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16.0),
            signInWithAppleButton.heightAnchor.constraint(equalToConstant: 50.0)
        ])
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
                let userObject = try await UserManager.shared.loadCurrentUser()
                delegate?.loginSheetViewControllerLoginSuccess(self, withUser: userObject)
                dismiss(animated: true)
            } catch {
                print("startSignInWithAppleFlow error \(error)")
            }
        }
    }
}
extension LoginSheetViewController {
    private func makeAppIconImageView() -> UIImageView {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 20
        imageView.layer.masksToBounds = true
        imageView.image = UIImage(named: "DrinkWhat-icon")
        return imageView
    }
    private func makeRemindLabel() -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .title2()
        label.textColor = UIColor.darkLogoBrown
        label.text = "請先登入會員"
        return label
    }
    private func makeDescriptionLabel() -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .regular3()
        label.textColor = UIColor.darkLogoBrown
        label.text = "登入會員即可使用個人化服務"
        return label
    }
    private func makeCloseButton() -> UIButton {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        let closeImage = UIImage(systemName: "xmark")?
            .withConfiguration(UIImage.SymbolConfiguration(pointSize: 18))
            .setColor(color: .darkLogoBrown)
        button.setImage(closeImage, for: .normal)
        button.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
        return button

    }
    @objc private func closeButtonTapped() {
        dismiss(animated: true)
    }
}
