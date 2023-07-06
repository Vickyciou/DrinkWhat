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
//    private lazy var loginWithLineButton = LoginButton()
    private lazy var signInWithAppleButton = ASAuthorizationAppleIDButton(type: .signIn, style: .black)
    private lazy var skipButton: UIButton = makeSkipButton()
    private var currentNonce: String?
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
            appIconImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 100),
            appIconImageView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            appIconImageView.heightAnchor.constraint(equalToConstant: 120),
            appIconImageView.widthAnchor.constraint(equalToConstant: 120),
            appNameLabel.topAnchor.constraint(equalTo: appIconImageView.bottomAnchor, constant: 12),
            appNameLabel.centerXAnchor.constraint(equalTo: appIconImageView.centerXAnchor),
//            loginWithLineButton.topAnchor.constraint(equalTo: appNameLabel.bottomAnchor, constant: 80),
//            loginWithLineButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            signInWithAppleButton.topAnchor.constraint(equalTo: appNameLabel.bottomAnchor, constant: 100),
            signInWithAppleButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            skipButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50),
            skipButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor)
        ])
//        loginWithLineButton.translatesAutoresizingMaskIntoConstraints = false
//        loginWithLineButton.delegate = self
//        loginWithLineButton.permissions = [.profile]
//        loginWithLineButton.presentingViewController = self

        signInWithAppleButton.translatesAutoresizingMaskIntoConstraints = false
        signInWithAppleButton.addTarget(self, action: #selector(startSignInWithAppleFlow), for: .touchUpInside)
    }

    @objc func startSignInWithAppleFlow() {
        Task {
            do {
                let helper = SignInWithAppleHelper(viewController: self)
                let tokens = try await helper.startSignInWithAppleFlow()
                let authDataResult = try await AuthManager.shared.signInWithApple(tokens: tokens)
                let user = UserObject(auth: authDataResult)
                try await UserManager.shared.createUserData(userObject: user)
                try await UserManager.shared.loadCurrentUser()
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
        imageView.layer.cornerRadius = 60
        imageView.layer.masksToBounds = true
        imageView.image = UIImage(named: "DrinkWhatAppIcon")
        return imageView
    }
    private func makeAppNameLabel() -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .medium(size: 20)
        label.textColor = UIColor.darkBrown
        label.text = "Drink What?"
        return label
    }
    private func makeSkipButton() -> UIButton {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(.lightGray, for: .normal)
        button.titleLabel?.font = .regular(size: 16)
        button.setTitle("稍候再說 >", for: .normal)
        button.addTarget(self, action: #selector(skipButtonTapped), for: .touchUpInside)
        return button
    }
    @objc func skipButtonTapped() {
        delegate?.loginViewControllerDismissSelf(self)
    }

}
//extension LoginViewController: LoginButtonDelegate {
//    func loginButton(_ button: LoginButton, didSucceedLogin loginResult: LoginResult) {
//        print("Login Succeeded.")
//    }
//
//    func loginButton(_ button: LoginButton, didFailLogin error: LineSDKError) {
//        print("Error: \(error)")
//    }
//
//    func loginButtonDidStartLogin(_ button: LoginButton) {
//        print("Login Started.")
//    }
//    func login() {
//        LoginManager.shared.login(permissions: [.profile], in: self) { result in
//            switch result {
//            case .success(let loginResult):
//                print(loginResult.accessToken.value)
//                // Do other things you need with the login result
//            case .failure(let error):
//                print(error)
//            }
//        }
//    }
//}

