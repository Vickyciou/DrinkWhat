//
//  LoginViewController.swift
//  DrinkWhat
//
//  Created by Vickyciou on 2023/6/19.
//

import UIKit
import AuthenticationServices
import Auth0
import CryptoKit
import FirebaseAuth

protocol LoginViewControllerDelegate: AnyObject {
    func loginViewControllerDismissSelf(_ viewController: LoginViewController, userObject: UserObject?)
}

class LoginViewController: UIViewController {
    private lazy var appIconImageView: UIImageView = makeAppIconImageView()
    private lazy var appNameLabel: UILabel = makeAppNameLabel()
//    private lazy var signInWithAppleButton = ASAuthorizationAppleIDButton(type: .signIn, style: .black)
    private lazy var skipButton: UIButton = makeSkipButton()
    private lazy var signInWithAuth0Button: UIButton = makeAuth0Button()
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
        
        let helper = SignInWithAuth0Helper()
//        Task {
//            try await helper.clearSessionWithAuth0()
//        }
    }
    private func setupVC() {
        view.backgroundColor = .white
        setupMainView()
    }

    private func setupMainView() {
        let contents = [appIconImageView, appNameLabel, signInWithAuth0Button, skipButton]
        contents.forEach { view.addSubview($0) }
        NSLayoutConstraint.activate([
            appIconImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 150),
            appIconImageView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            appIconImageView.heightAnchor.constraint(equalToConstant: 150),
            appIconImageView.widthAnchor.constraint(equalToConstant: 150),
            
            appNameLabel.topAnchor.constraint(equalTo: appIconImageView.bottomAnchor, constant: 20),
            appNameLabel.centerXAnchor.constraint(equalTo: appIconImageView.centerXAnchor),
            
            skipButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50),
            skipButton.heightAnchor.constraint(equalToConstant: 50),
            skipButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 32),
            skipButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -32),
            
            signInWithAuth0Button.bottomAnchor.constraint(equalTo: skipButton.topAnchor, constant: -20),
            signInWithAuth0Button.trailingAnchor.constraint(equalTo: skipButton.trailingAnchor),
            signInWithAuth0Button.leadingAnchor.constraint(equalTo: skipButton.leadingAnchor),
            signInWithAuth0Button.heightAnchor.constraint(equalTo: skipButton.heightAnchor),
            
        ])

//        signInWithAppleButton.translatesAutoresizingMaskIntoConstraints = false
//        signInWithAppleButton.addTarget(self, action: #selector(startSignInWithAppleFlow), for: .touchUpInside)
        
    }

//    @objc private func startSignInWithAppleFlow() {
//        Task {
//            do {
//                let helper = SignInWithAppleHelper(viewController: self)
//                let tokens = try await helper.startSignInWithAppleFlow()
//                let authDataResult = try await userManager.signInWithApple(tokens: tokens)
//                let user = UserObject(auth: authDataResult)
//                try await userManager.createUserData(userObject: user)
//                let userObject = try await userManager.loadCurrentUser()
//                delegate?.loginViewControllerDismissSelf(self, userObject: userObject)
//            } catch {
//                print("startSignInWithAppleFlow error \(error)")
//            }
//        }
//    }
    
    @objc private func startSignInWithAuth0Flow() {
        Task {
            do {
                let helper = SignInWithAuth0Helper()
                let tokens = try await helper.loginWithAuth0()
                let authDataResult = try await userManager.signInWithAuth0(tokens: tokens)
                let user = UserObject(auth: authDataResult)
                try await userManager.createUserData(userObject: user)
                let userObject = try await userManager.loadCurrentUser()
                delegate?.loginViewControllerDismissSelf(self, userObject: userObject)
            } catch {
                print("startSignInWithAuth0Flow error \(error)")
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
        imageView.image = UIImage(named: "DrinkWhat-icon")
        return imageView
    }
    private func makeAppNameLabel() -> UILabel {
        let label = UILabel()
        let optimaBoldFont = UIFont(name: "Marker Felt Wide", size: 36)
        let attributes: [NSAttributedString.Key: Any] = [
            .font: optimaBoldFont as Any,
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
        delegate?.loginViewControllerDismissSelf(self, userObject: nil)
    }

    private func makeAuth0Button() -> UIButton {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .medium2()
        button.setTitle("Sign in With Auth0", for: .normal)
        button.backgroundColor = .black
        button.layer.borderColor = UIColor.darkGray.cgColor
        button.layer.borderWidth = 2
        button.layer.cornerRadius = 5
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(startSignInWithAuth0Flow), for: .touchUpInside)
        return button
    }
}
