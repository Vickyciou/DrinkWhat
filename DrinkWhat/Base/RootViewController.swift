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
//            case let (true, url?):
//                let lvc = LoginViewController()
//                lvc.delegate = self
//                return lvc
            case (true, _):
                let lvc = LoginViewController()
                lvc.delegate = self
                return lvc
            case let (false, url?):
                try await UserManager.shared.loadCurrentUser()
                if let groupID = groupID(url) {
                    let tabBarVC = TabBarViewController(groupID: groupID)
                    tabBarVC.tabBardelegate = self
                    return tabBarVC
                } else if let orderID = orderID(url) {
                    let tabBarVC = TabBarViewController(orderID: orderID)
                    tabBarVC.tabBardelegate = self
                    return tabBarVC
                } else {
                    let tabBarVC = TabBarViewController()
                    tabBarVC.tabBardelegate = self
                    return tabBarVC
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
    private func orderID(_ url: URL) -> String? {
        if url.host == "share" {
            return url.queryParameters?["orderID"]
        } else {
            return nil
        }
    }
}

extension RootViewController: LoginViewControllerDelegate {
    func loginViewControllerDidLoginSuccess(_ viewController: LoginViewController) {
        viewController.willMove(toParent: nil)
        viewController.view.removeFromSuperview()
        viewController.removeFromParent()
        let tabBarVC = {
            if let url, let groupID = groupID(url) {
                let tabBarVC = TabBarViewController(groupID: groupID)
                tabBarVC.tabBardelegate = self
                return tabBarVC
            } else if let url, let orderID = orderID(url) {
                let tabBarVC = TabBarViewController(orderID: orderID)
                tabBarVC.tabBardelegate = self
                return tabBarVC
            } else {
                return TabBarViewController()
            }
        }()
        displayViewControllerAsMain(tabBarVC)
        tabBarVC.tabBardelegate = self
    }
}
extension RootViewController: TabBarViewControllerDelegate {
    func getProfileViewControllerDidPressLogOut(_ viewController: TabBarViewController) {
        viewController.willMove(toParent: nil)
        viewController.view.removeFromSuperview()
        viewController.removeFromParent()
        let loginVC = LoginViewController()
        loginVC.delegate = self
        displayViewControllerAsMain(loginVC)
    }
}

extension UIViewController {
    func displayViewControllerAsMain(_ viewController: UIViewController) {
        addChild(viewController)
        view.addSubview(viewController.view)
        viewController.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate(
            [
                viewController.view.topAnchor.constraint(equalTo: view.topAnchor),
                viewController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
                viewController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                viewController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor)
            ]
        )
        viewController.didMove(toParent: self)
    }
}
