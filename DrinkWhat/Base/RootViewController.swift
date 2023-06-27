//
//  RootViewController.swift
//  DrinkWhat
//
//  Created by Vickyciou on 2023/6/27.
//

import UIKit

class RootViewController: UIViewController {
    private var showLoginView: Bool = false
    private let url: URL?

    init(url: URL? = nil) {
        self.url = url
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        let authUser = try? AuthManager.shared.getAuthenticatedUser()
        self.showLoginView = authUser == nil
        Task {
            do {
//                try AuthManager.shared.signOut()
                try await decideVC()
            } catch {
                print("decideVC error")
            }
        }
    }

    func decideVC() async throws {
        let myVC: UIViewController = try await {
            switch (showLoginView, url) {
            case let (true, url?):
                let aaa = url
                let lvc = LoginViewController()
                lvc.delegate = self
                return lvc
            case (true, _):
                let lvc = LoginViewController()
                lvc.delegate = self
                return lvc
            case let (false, url?):
                try await UserManager.shared.loadCurrentUser()
                if let groupID = groupID(url) {
                    return TabBarViewController(groupID: groupID)
                } else {
                    return TabBarViewController()
                }
            case (false, _):
                try await UserManager.shared.loadCurrentUser()
                return TabBarViewController()
            }
        }()
        displayViewControllerAsMain(myVC)
    }

    private func groupID(_ url: URL) -> String? {
        if url.host == "share" {
            return url.queryParameters?["groupID"]
        } else {
            return nil
        }
    }
}

extension RootViewController: LoginViewControllerDelegate {
    func loginViewControllerDidLoginSuccess(_ vc: LoginViewController) {
        vc.willMove(toParent: nil)
        vc.view.removeFromSuperview()
        vc.removeFromParent()
        let tabBarVC = {
            if let url {
                return TabBarViewController(groupID: groupID(url))
            } else {
                return TabBarViewController()
            }
        }()
        displayViewControllerAsMain(tabBarVC)
    }
}

extension UIViewController {
    func displayViewControllerAsMain(_ vc: UIViewController) {
        addChild(vc)
        view.addSubview(vc.view)
        vc.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate(
            [
                vc.view.topAnchor.constraint(equalTo: view.topAnchor),
                vc.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
                vc.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                vc.view.trailingAnchor.constraint(equalTo: view.trailingAnchor)
            ]
        )
        vc.didMove(toParent: self)
    }
}
