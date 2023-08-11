//
//  ProfileViewController.swift
//  DrinkWhat
//
//  Created by Vickyciou on 2023/6/15.
//

import UIKit
import PhotosUI

protocol ProfileViewControllerDelegate: AnyObject {
    func profileViewControllerDidPressLogOut(_ viewController: ProfileViewController)
}

class ProfileViewController: UIViewController {
    private lazy var nameLabel: UILabel = makeNameLabel()
    private lazy var emailLabel: UILabel = makeEmailLabel()
    private lazy var imageView: UIImageView = makeImageView()
    private lazy var cameraButton: UIButton = makeCameraButton()
    private lazy var logOutButton: UIButton = makeLogOutButton()
    private lazy var deleteButton: UIButton = makeDeleteButton()
    private var userObject: UserObject

    weak var delegate: ProfileViewControllerDelegate?
    private let firebaseStorageManager = FirebaseStorageManager()
    private let userManager = UserManager.shared

    init(userObject: UserObject) {
        self.userObject = userObject
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
        setupLogOUtButton()
        setNavController()
    }

    private func setNavController() {
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = UIColor.white
        appearance.titleTextAttributes = [.foregroundColor: UIColor.darkLogoBrown]
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.darkLogoBrown]
        appearance.shadowColor = UIColor.clear
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationItem.title = "個人帳戶"
        tabBarController?.tabBar.backgroundColor = .white
    }

    private func setupLogOUtButton() {
        let contents = [nameLabel, emailLabel, imageView, cameraButton, logOutButton, deleteButton]
        contents.forEach { view.addSubview($0) }
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 80),
            imageView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            imageView.heightAnchor.constraint(equalToConstant: 120),
            imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor),
            cameraButton.heightAnchor.constraint(equalToConstant: 30),
            cameraButton.widthAnchor.constraint(equalToConstant: 30),
            cameraButton.bottomAnchor.constraint(equalTo: imageView.bottomAnchor, constant: -2),
            cameraButton.trailingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: -10),
            nameLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 16),
            nameLabel.centerXAnchor.constraint(equalTo: imageView.centerXAnchor),
            emailLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
            emailLabel.centerXAnchor.constraint(equalTo: imageView.centerXAnchor),
            logOutButton.topAnchor.constraint(equalTo: emailLabel.bottomAnchor, constant: 150),
            logOutButton.widthAnchor.constraint(equalToConstant: 150),
            logOutButton.heightAnchor.constraint(equalToConstant: 40),
            logOutButton.centerXAnchor.constraint(equalTo: imageView.centerXAnchor),
            deleteButton.topAnchor.constraint(equalTo: logOutButton.bottomAnchor, constant: 25),
            deleteButton.centerXAnchor.constraint(equalTo: imageView.centerXAnchor),
            deleteButton.widthAnchor.constraint(equalToConstant: 150),
            deleteButton.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
}
extension ProfileViewController {
    private func makeNameLabel() -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.font = .title1()
        label.textColor = UIColor.darkLogoBrown
        label.text = userObject.userName
        return label
    }

    private func makeEmailLabel() -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.font = .regular4()
        label.textColor = UIColor.darkLogoBrown
        label.text = userObject.email
        return label
    }

    private func makeImageView() -> UIImageView {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 60
        imageView.layer.masksToBounds = true
        imageView.loadImage(userObject.userImageURL,
                            placeHolder: UIImage(systemName: "person.circle.fill")?.setColor(color: .darkBrown))

        return imageView
    }
    private func makeCameraButton() -> UIButton {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        let normalBackground = UIColor.white.toImage(size: CGSize(width: 65, height: 25))
        button.setBackgroundImage(normalBackground, for: .normal)
        button.layer.cornerRadius = 15
        button.layer.masksToBounds = true
        let cameraImage = UIImage(systemName: "camera.circle")?
            .withConfiguration(UIImage.SymbolConfiguration(scale: .large))
            .setColor(color: .darkGray)
        button.setImage(cameraImage, for: .normal)
        button.addTarget(self, action: #selector(cameraButtonTapped), for: .touchUpInside)
        return button
    }
    @objc func cameraButtonTapped() {
        var configuration = PHPickerConfiguration()
        configuration.filter = .images
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = self
        present(picker, animated: true)
    }

    private func makeLogOutButton() -> UIButton {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = .regular4()
        let normalBackground = UIColor.darkLogoBrown.toImage(size: CGSize(width: 65, height: 25))
        let selectedBackground = UIColor.darkLogoBrown
            .withAlphaComponent(0.8)
            .toImage(size: CGSize(width: 65, height: 25))
        button.setBackgroundImage(normalBackground, for: .normal)
        button.setBackgroundImage(selectedBackground, for: .highlighted)
        button.layer.cornerRadius = 5
        button.layer.masksToBounds = true
        button.setTitle("登出", for: .normal)
        button.addTarget(self, action: #selector(logOutButtonTapped), for: .touchUpInside)
        return button
    }
    @objc func logOutButtonTapped() {
        userManager.signOut()
        delegate?.profileViewControllerDidPressLogOut(self)
    }

    private func makeDeleteButton() -> UIButton {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(UIColor.red, for: .normal)
        button.setTitleColor(UIColor.systemPink, for: .highlighted)
        button.titleLabel?.font = .regular(size: 14)
        let normalBackground = UIColor.white.toImage(size: CGSize(width: 65, height: 25))
        let selectedBackground = UIColor.lightBrown.withAlphaComponent(0.5).toImage(size: CGSize(width: 65, height: 25))
        button.setBackgroundImage(normalBackground, for: .normal)
        button.setBackgroundImage(selectedBackground, for: .highlighted)
        button.setTitle("刪除帳號", for: .normal)
        button.layer.cornerRadius = 5
        button.layer.masksToBounds = true
        button.layer.borderColor = UIColor.darkBrown.cgColor
        button.layer.borderWidth = 1
        button.addTarget(self, action: #selector(deleteButtonTapped), for: .touchUpInside)
        return button
    }
    @objc func deleteButtonTapped() {
        let alert = UIAlertController(
            title: "注意！",
            message: "確定要刪除帳號嗎？",
            preferredStyle: .alert
        )
        let okAction = UIAlertAction(title: "確定", style: .default) { [weak self]_ in
            guard let self else { return }
            Task {
                do {
                    let deleteHelper = DeleteWithAppleHelper(viewController: self)
                    let deleteAppleResult = try await deleteHelper.deleteWithAppleFlow()
                    try await self.userManager.deleteUser(tokens: deleteAppleResult)
                    self.delegate?.profileViewControllerDidPressLogOut(self)
                } catch {
                    print("delete user error")
                }
            }
        }
        let cancelAction = UIAlertAction(title: "取消", style: .cancel)
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        present(alert, animated: true)

    }
}

extension ProfileViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)

        let itemProviders = results.map(\.itemProvider)
        if let itemProvider = itemProviders.first, itemProvider.canLoadObject(ofClass: UIImage.self) {
            itemProvider.loadObject(ofClass: UIImage.self) { [weak self] (image, error) in
                guard let self = self, let image = image as? UIImage else { return }
                self.firebaseStorageManager.uploadPhoto(image: image) { result in
                    switch result {
                    case .success(let url):
                        self.userManager.updateUserImage(userID: self.userObject.userID, imageURL: url.absoluteString)
                    case .failure(let error):
                        print("Update user image fail: \(error)")
                    }
                }
                DispatchQueue.main.async {
                    self.imageView.image = image
                }
            }
        }
    }
}
