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

class LoginViewController: UIViewController {
    private lazy var appIconImageView: UIImageView = makeAppIconImageView()
    private lazy var appNameLabel: UILabel = makeAppNameLabel()
    private lazy var loginWithLineButton = LoginButton()
    private lazy var signInWithAppleButton = ASAuthorizationAppleIDButton(type: .signIn, style: .black)
    private var currentNonce: String?

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
        setNavController()
        setupMainView()
//        setVickyLoginButton()
//        setUser2LoginButton()
    }
    private func setNavController() {
        let navigationController = UINavigationController()
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = UIColor.white
        appearance.titleTextAttributes = [.foregroundColor: UIColor.darkBrown]
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.darkBrown]
        appearance.shadowColor = UIColor.clear
        navigationController.navigationBar.standardAppearance = appearance
        navigationController.navigationBar.scrollEdgeAppearance = appearance
        navigationItem.title = "Sign in"
        tabBarController?.tabBar.backgroundColor = .white
        navigationItem.hidesBackButton = true
        let closeImage = UIImage(systemName: "xmark")?
            .withConfiguration(UIImage.SymbolConfiguration(pointSize: 20))
            .withTintColor(UIColor.darkBrown)
            .withRenderingMode(.alwaysOriginal)
        let closeButton = UIBarButtonItem(image: closeImage,
                                          style: .plain,
                                          target: self,
                                          action: #selector(closeButtonTapped))
        navigationItem.setRightBarButton(closeButton, animated: false)
    }
    @objc private func closeButtonTapped() {
        show(TabBarViewController(), sender: nil)
        dismiss(animated: false)
    }
    private func setupMainView() {
        let contents = [appIconImageView, appNameLabel, loginWithLineButton, signInWithAppleButton]
        contents.forEach { view.addSubview($0) }
        NSLayoutConstraint.activate([
            appIconImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 100),
            appIconImageView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            appIconImageView.heightAnchor.constraint(equalToConstant: 120),
            appIconImageView.widthAnchor.constraint(equalToConstant: 120),
            appNameLabel.topAnchor.constraint(equalTo: appIconImageView.bottomAnchor, constant: 12),
            appNameLabel.centerXAnchor.constraint(equalTo: appIconImageView.centerXAnchor),
            loginWithLineButton.topAnchor.constraint(equalTo: appNameLabel.bottomAnchor, constant: 80),
            loginWithLineButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            signInWithAppleButton.topAnchor.constraint(equalTo: loginWithLineButton.bottomAnchor, constant: 50),
            signInWithAppleButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        loginWithLineButton.translatesAutoresizingMaskIntoConstraints = false
        loginWithLineButton.delegate = self
        loginWithLineButton.permissions = [.profile]
        loginWithLineButton.presentingViewController = self

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
            } catch {
                print("startSignInWithAppleFlow error \(error)")
            }
        }
//        let nonce = randomNonceString()
//        currentNonce = nonce
//        let appleIDProvider = ASAuthorizationAppleIDProvider()
//        let request = appleIDProvider.createRequest()
//        request.requestedScopes = [.fullName, .email]
//        request.nonce = sha256(nonce)
//
//        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
//        authorizationController.delegate = self
//        authorizationController.presentationContextProvider = self
//        authorizationController.performRequests()
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

}
extension LoginViewController: LoginButtonDelegate {
    func loginButton(_ button: LoginButton, didSucceedLogin loginResult: LoginResult) {
        print("Login Succeeded.")
    }

    func loginButton(_ button: LoginButton, didFailLogin error: LineSDKError) {
        print("Error: \(error)")
    }

    func loginButtonDidStartLogin(_ button: LoginButton) {
        print("Login Started.")
    }
    func login() {
        LoginManager.shared.login(permissions: [.profile], in: self) { result in
            switch result {
            case .success(let loginResult):
                print(loginResult.accessToken.value)
                // Do other things you need with the login result
            case .failure(let error):
                print(error)
            }
        }
    }
}
//extension LoginViewController {
//
//    func setVickyLoginButton() {
//        let userVickyButton = UIButton()
//        view.addSubview(userVickyButton)
//        userVickyButton.translatesAutoresizingMaskIntoConstraints = false
//        userVickyButton.backgroundColor = .orangeBrown
//        userVickyButton.setTitleColor(UIColor.midiumBrown, for: .normal)
//        userVickyButton.titleLabel?.font = .regular(size: 14)
//        userVickyButton.setTitle("Vicky Login", for: .normal)
//        userVickyButton.addTarget(self, action: #selector(vickyButtonTapped(_:)), for: .touchUpInside)
//        NSLayoutConstraint.activate([
//            userVickyButton.centerYAnchor.constraint(equalTo: signInWithAppleButton.bottomAnchor, constant: 50),
//            userVickyButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor)])
//        let vicky = UserObject(userID: "UUID1", userName: "Vicky", userImageURL: "", favoriteShops: [])
//        UserManager.shared.createUserData(userObject: vicky)
//    }
//    @objc func vickyButtonTapped(_ sender: UIButton) {
//        UserManager.shared.getUserData(userID: "UUID1")
//        show(TabBarViewController(), sender: nil)
//        dismiss(animated: false)
//    }
//
//    func setUser2LoginButton() {
//        let user2Button = UIButton()
//        view.addSubview(user2Button)
//        user2Button.translatesAutoresizingMaskIntoConstraints = false
//        user2Button.backgroundColor = .orangeBrown
//        user2Button.setTitleColor(UIColor.midiumBrown, for: .normal)
//        user2Button.titleLabel?.font = .regular(size: 14)
//        user2Button.setTitle("User2 Login", for: .normal)
//        user2Button.addTarget(self, action: #selector(user2ButtonTapped(_:)), for: .touchUpInside)
//        NSLayoutConstraint.activate([
//            user2Button.centerYAnchor.constraint(equalTo: signInWithAppleButton.bottomAnchor, constant: 100),
//            user2Button.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor)])
//        let user2 = UserObject(userID: "UUID2", userName: "User2", userImageURL: "", favoriteShops: [])
//        UserManager.shared.createUserData(userObject: user2)
//    }
//    @objc func user2ButtonTapped(_ sender: UIButton) {
//        UserManager.shared.getUserData(userID: "UUID2")
//        show(TabBarViewController(), sender: nil)
//        dismiss(animated: false)
//    }
//
//
//}

extension LoginViewController {
    private func randomNonceString(length: Int = 32) -> String {
        precondition(length > 0)
        let charset: [Character] =
        Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
        var result = ""
        var remainingLength = length

        while remainingLength > 0 {
            let randoms: [UInt8] = (0 ..< 16).map { _ in
                var random: UInt8 = 0
                let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
                if errorCode != errSecSuccess {
                    fatalError(
                        "Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)"
                    )
                }
                return random
            }

            randoms.forEach { random in
                if remainingLength == 0 {
                    return
                }

                if random < charset.count {
                    result.append(charset[Int(random)])
                    remainingLength -= 1
                }
            }
        }

        return result
    }

    @available(iOS 13, *)
    private func sha256(_ input: String) -> String {
      let inputData = Data(input.utf8)
      let hashedData = SHA256.hash(data: inputData)
      let hashString = hashedData.compactMap {
        String(format: "%02x", $0)
      }.joined()

      return hashString
    }
}

extension LoginViewController: ASAuthorizationControllerDelegate {
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
          guard let nonce = currentNonce else {
            fatalError("Invalid state: A login callback was received, but no login request was sent.")
          }
          guard let appleIDToken = appleIDCredential.identityToken else {
            print("Unable to fetch identity token")
            return
          }
          guard let idTokenString = String(data: appleIDToken, encoding: .utf8)
            else {
            print("Unable to serialize token string from data: \(appleIDToken.debugDescription)")
            return
          }
            let credential = OAuthProvider.credential(
                withProviderID: "apple.com",
                idToken: idTokenString,
                rawNonce: nonce
            )
            // Sign in with Firebase.
            Auth.auth().signIn(with: credential) { (authResult, error) in
                if let error {
                    print(error.localizedDescription)
                    return
                }
                if let _ = authResult {
                    let tabBarVC = TabBarViewController()
                    self.present(tabBarVC, animated: false)
                }
            }
        }
    }

    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        // Handle error.
        print("Sign in with Apple errored: \(error)")
    }
}

