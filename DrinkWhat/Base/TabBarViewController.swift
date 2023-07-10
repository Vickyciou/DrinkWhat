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

    private let tabs: [Tab] = [.home, .vote, .order, .profile]
    private let groupManager = GroupManager()
    private let orderManager = OrderManager()
    private var userObject = UserManager.shared.userObject
    private let groupID: String?
    private let orderID: String?
    weak var tabBardelegate: TabBarViewControllerDelegate?

    init(groupID: String? = nil, orderID: String? = nil) {
        self.groupID = groupID
        self.orderID = orderID
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        viewControllers = tabs.map { $0.makeViewController() }
        switchToGroupIndex()
        switchToOrderIndex()
        let profileVC = (viewControllers?.last as? UINavigationController)?.viewControllers.first as? ProfileViewController
        profileVC?.delegate = self
        delegate = self

        let appearance = UITabBarAppearance()
        appearance.backgroundColor = UIColor.logoBrown
        tabBarController?.tabBar.standardAppearance = appearance
        tabBarController?.tabBar.scrollEdgeAppearance = appearance
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        navigationController?.setNavigationBarHidden(false, animated: animated)
    }

    private func switchToGroupIndex() {
        guard let groupID else { return }
        selectedIndex = 1
        userObject.map {
            groupManager.addUserIntoGroup(groupID: groupID, userID: "\($0.userID)")
        }
    }
    private func switchToOrderIndex() {
        guard let orderID, let userObject else { return }
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
//        case favorite
        case vote
        case order
        case profile

        func makeViewController() -> UIViewController {
            let controller: UIViewController
            let userManager = UserManager()
            switch self {
            case .home: controller = UINavigationController(rootViewController: HomeViewController())
//            case .favorite: controller = UINavigationController(rootViewController: FavoriteViewController())
            case .vote: controller = UINavigationController(rootViewController: VoteViewController())
            case .order: controller = UINavigationController(rootViewController: OrderViewController())
            case .profile: controller = UINavigationController(rootViewController: ProfileViewController())

            }
            controller.tabBarItem = makeTabBarItem()
            controller.tabBarItem.imageInsets = UIEdgeInsets(top: 6.0, left: 0.0, bottom: -6.0, right: 0.0)
            return controller
        }
        private func makeTabBarItem() -> UITabBarItem {
            return UITabBarItem(title: nil, image: normalImage, selectedImage: selectedImage)
        }
        private var normalImage: UIImage? {
            switch self {
            case .home:
                return UIImage(systemName: "house")?.setColor(color: .darkLogoBrown)
//            case .favorite:
//                return UIImage(systemName: "heart")?.setColor(color: .darkBrown)
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
//            case .favorite:
//                return UIImage(systemName: "heart.fill")?.setColor(color: .darkBrown)
            case .vote:
                return UIImage(systemName: "hand.tap.fill")?.setColor(color: .darkLogoBrown)
            case .order:
                return UIImage(systemName: "doc.text.fill")?.setColor(color: .darkLogoBrown)
            case .profile:
                return UIImage(systemName: "person.fill")?.setColor(color: .darkLogoBrown)
            }
        }
    }
}

extension TabBarViewController: ProfileViewControllerDelegate {
    func profileViewControllerDidPressLogOut(_ viewController: ProfileViewController) {
        tabBardelegate?.getProfileViewControllerDidPressLogOut(self)
    }
}

extension TabBarViewController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        if
            let navVC = viewController as? UINavigationController,
            navVC.viewControllers.first is HomeViewController {
            return true
        } else {
            let authUser = try? AuthManager.shared.getAuthenticatedUser()
            if authUser == nil {
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
    func loginSheetViewControllerLoginSuccess(_ viewController: LoginSheetViewController) {
        makeAlertToast(message: "登入成功", title: nil, duration: 2)
    }


}
