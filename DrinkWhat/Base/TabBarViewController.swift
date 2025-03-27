//
//  TabBarViewController.swift
//  DrinkWhat
//
//  Created by Vickyciou on 2023/6/15.
//

import UIKit

protocol TabBarViewControllerDelegate: AnyObject {
    func getProfileViewControllerDidPressLogOut(_ viewController: TabBarViewController)
}

class TabBarViewController: UITabBarController, UIViewControllerTransitioningDelegate {

    private let customTabs: [Tab] = [.home, .vote, .order, .profile]
    private let groupManager = GroupManager()
    private let orderManager = OrderManager()
    private let userManager = UserManager.shared
    private(set) var userObject: UserObject?
    private let groupID: String?
    private let orderID: String?
    weak var tabBarDelegate: TabBarViewControllerDelegate?

    init(userObject: UserObject? = nil, groupID: String? = nil, orderID: String? = nil) {
        self.groupID = groupID
        self.orderID = orderID
        self.userObject = userObject
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        if userObject == nil {
            viewControllers = customTabs.map { makeViewController(tab: $0, userObject: nil) }
            delegate = self
        } else {
            viewControllers = customTabs.map { makeViewController(tab: $0, userObject: userObject) }
            switchToGroupIndex()
            switchToOrderIndex()
            delegate = self
        }

        let appearance = UITabBarAppearance()
        appearance.backgroundColor = .white
        tabBarController?.tabBar.standardAppearance = appearance
        tabBarController?.tabBar.scrollEdgeAppearance = appearance
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        navigationController?.setNavigationBarHidden(false, animated: animated)
    }

    private func switchToGroupIndex() {
        guard let groupID, let userObject
        else { return }
        selectedIndex = 1

        groupManager.addUserIntoGroup(groupID: groupID, userID: userObject.userID)

    }
    private func switchToOrderIndex() {
        guard let orderID, let userObject
        else { return }
        selectedIndex = 2
        Task {
            do {
                try await orderManager.addUserIntoOrderGroup(userID: userObject.userID, orderID: orderID)
            } catch ManagerError.hadActiveOrderGroup {
                let alert = UIAlertController(
                    title: "加入團購群組失敗",
                    message: "目前已有進行中的團購群組囉！\n請先完成進行中的群組~",
                    preferredStyle: .alert
                )
                let okAction = UIAlertAction(title: "OK", style: .default)
                alert.addAction(okAction)
                present(alert, animated: true)
            } catch ManagerError.alreadyAddAnotherOrderError {
                let alert = UIAlertController(
                    title: "加入團購群組失敗",
                    message: "目前已有進行中的團購群組囉！\n請先完成進行中的群組~",
                    preferredStyle: .alert
                )
                let okAction = UIAlertAction(title: "OK", style: .default)
                alert.addAction(okAction)
                present(alert, animated: true)
            }
        }
    }
}

extension TabBarViewController {
    private enum Tab {
        case home
        case vote
        case order
        case profile

        func makeTabBarItem() -> UITabBarItem {
            return UITabBarItem(title: nil, image: normalImage, selectedImage: selectedImage)
        }
        private var normalImage: UIImage? {
            switch self {
            case .home:
                return UIImage(systemName: "house")?.setColor(color: .darkLogoBrown)
            case .vote:
                return UIImage(systemName: "hand.tap")?.setColor(color: .darkLogoBrown)
            case .order:
                return UIImage(systemName: "doc.text")?.setColor(color: .darkLogoBrown)
            case .profile:
                return UIImage(systemName: "person")?.setColor(color: .darkLogoBrown)
            }
        }
        private var selectedImage: UIImage? {
            switch self {
            case .home:
                return UIImage(systemName: "house.fill")?.setColor(color: .darkLogoBrown)
            case .vote:
                return UIImage(systemName: "hand.tap.fill")?.setColor(color: .darkLogoBrown)
            case .order:
                return UIImage(systemName: "doc.text.fill")?.setColor(color: .darkLogoBrown)
            case .profile:
                return UIImage(systemName: "person.fill")?.setColor(color: .darkLogoBrown)
            }
        }
    }

    private func makeViewController(tab: Tab, userObject: UserObject?) -> UIViewController {
        let controller: UIViewController
        switch tab {
        case .home:
            controller = UINavigationController(rootViewController: HomeViewController())
        case .vote:
            controller = UINavigationController(
                rootViewController: userObject.map { VoteViewController(userObject: $0) } ?? UIViewController())
        case .order:
            controller = UINavigationController(
                rootViewController: userObject.map { OrderViewController(userObject: $0) } ?? UIViewController())
        case .profile:
            let rootViewController: UIViewController = {
                if let userObject {
                    let profileViewController = ProfileViewController(userObject: userObject)
                    profileViewController.delegate = self
                    return profileViewController
                } else {
                    return UIViewController()
                }
            }()
            controller = UINavigationController(rootViewController: rootViewController)
        }
        controller.tabBarItem = tab.makeTabBarItem()
        controller.tabBarItem.imageInsets = UIEdgeInsets(top: 6.0, left: 0.0, bottom: -6.0, right: 0.0)
        return controller
    }
}

extension TabBarViewController: ProfileViewControllerDelegate {
    func profileViewControllerDidPressLogOut(_ viewController: ProfileViewController) {
        tabBarDelegate?.getProfileViewControllerDidPressLogOut(self)
    }
}

extension TabBarViewController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        if let navVC = viewController as? UINavigationController,
           navVC.viewControllers.first is HomeViewController {
            return true
        } else {
            if userObject == nil {
                let loginVC = LoginSheetViewController()
                loginVC.delegate = self
                loginVC.modalPresentationStyle = .pageSheet
                if let sheet = loginVC.sheetPresentationController {
                    sheet.detents = [.medium()]
                }
                present(loginVC, animated: true, completion: nil)
                return false
            } else {
                return true
            }
        }
    }
}

extension TabBarViewController: LoginSheetViewControllerDelegate {
    func loginSheetViewControllerLoginSuccess(_ viewController: LoginSheetViewController, withUser userObject: UserObject) {
        self.userObject = userObject
        viewControllers = customTabs.map { makeViewController(tab: $0, userObject: userObject) }
        makeAlertToast(message: "登入成功", title: nil, duration: 2)
    }
}
