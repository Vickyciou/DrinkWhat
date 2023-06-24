//
//  LoginViewController.swift
//  DrinkWhat
//
//  Created by Vickyciou on 2023/6/19.
//

import UIKit
import LineSDK

class LoginViewController: UIViewController {
    private lazy var appIconImageView: UIImageView = makeAppIconImageView()
    private lazy var appNameLabel: UILabel = makeAppNameLabel()
    private lazy var loginWithLineButton = LoginButton()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupVC()
    }
    private func setupVC() {
        view.backgroundColor = .white
        setNavController()
        setupMainView()
        setVickyLoginButton()
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
        let contents = [appIconImageView, appNameLabel, loginWithLineButton]
        contents.forEach { view.addSubview($0) }
        NSLayoutConstraint.activate([
            appIconImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 100),
            appIconImageView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            appIconImageView.heightAnchor.constraint(equalToConstant: 120),
            appIconImageView.widthAnchor.constraint(equalToConstant: 120),
            appNameLabel.topAnchor.constraint(equalTo: appIconImageView.bottomAnchor, constant: 12),
            appNameLabel.centerXAnchor.constraint(equalTo: appIconImageView.centerXAnchor),
            loginWithLineButton.topAnchor.constraint(equalTo: appNameLabel.bottomAnchor, constant: 80),
            loginWithLineButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        loginWithLineButton.translatesAutoresizingMaskIntoConstraints = false
        loginWithLineButton.delegate = self
        loginWithLineButton.permissions = [.profile]
        loginWithLineButton.presentingViewController = self
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
extension LoginViewController {

    func setVickyLoginButton() {
        let userVickyButton = UIButton()
        view.addSubview(userVickyButton)
        userVickyButton.translatesAutoresizingMaskIntoConstraints = false
        userVickyButton.backgroundColor = .orangeBrown
        userVickyButton.setTitleColor(UIColor.midiumBrown, for: .normal)
        userVickyButton.titleLabel?.font = .regular(size: 14)
        userVickyButton.setTitle("Vicky Login", for: .normal)
        userVickyButton.addTarget(self, action: #selector(vickyButtonTapped(_:)), for: .touchUpInside)
        NSLayoutConstraint.activate([
            userVickyButton.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor, constant: 100),
            userVickyButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor)])
        let vicky = UserObject(userID: "UUID1", userName: "Vicky", userImageURL: "", favoriteShops: [])
        UserManager.shared.createUserData(userObject: vicky)
    }
    @objc func vickyButtonTapped(_ sender: UIButton) {
        UserManager.shared.getUserData(userID: "UUID1")
        show(TabBarViewController(), sender: nil)
        dismiss(animated: false)
    }


}
