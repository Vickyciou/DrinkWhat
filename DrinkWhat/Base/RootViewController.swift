//
//  RootViewController.swift
//  DrinkWhat
//
//  Created by Vickyciou on 2023/6/27.
//

import UIKit

class RootViewController: UIViewController {
    private var showLoginView: Bool = false
    private let userManager = UserManager.shared
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
        let authUser = try? userManager.checkCurrentUser()
        self.showLoginView = authUser == nil
        decideVC()
    }

    func decideVC() {
        let myVC: UIViewController = {
            switch (showLoginView, url) {
            case (true, _):
                let lvc = LoginViewController()
                lvc.delegate = self
                return lvc
            case let (false, url?):
                if let groupID = groupID(url) {
                    let tabBarVC = TabBarViewController(groupID: groupID)
                    tabBarVC.tabBarDelegate = self
                    return tabBarVC
                } else if let orderID = orderID(url) {
                    let tabBarVC = TabBarViewController(orderID: orderID)
                    tabBarVC.tabBarDelegate = self
                    return tabBarVC
                } else {
                    let tabBarVC = TabBarViewController()
                    tabBarVC.tabBarDelegate = self
                    return tabBarVC
                }
            case (false, _):
                let tabBarVC = TabBarViewController()
                tabBarVC.tabBarDelegate = self
                return tabBarVC
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
    func loginViewControllerDismissSelf(_ viewController: LoginViewController) {
        viewController.willMove(toParent: nil)
        viewController.view.removeFromSuperview()
        viewController.removeFromParent()
        let tabBarVC = {
            if let url, let groupID = groupID(url) {
                let tabBarVC = TabBarViewController(groupID: groupID)
                tabBarVC.tabBarDelegate = self
                return tabBarVC
            } else if let url, let orderID = orderID(url) {
                let tabBarVC = TabBarViewController(orderID: orderID)
                tabBarVC.tabBarDelegate = self
                return tabBarVC
            } else {
                let tabBarVC = TabBarViewController()
                tabBarVC.tabBarDelegate = self
                return tabBarVC
            }
        }()
        displayViewControllerAsMain(tabBarVC)
//        tabBarVC.tabBarDelegate = self
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
