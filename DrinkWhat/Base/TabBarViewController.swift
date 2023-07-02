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
class TabBarViewController: UITabBarController {
    private let tabs: [Tab] = [.home, .favorite, .vote, .order, .profile]
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
        view.backgroundColor = .white
        viewControllers = tabs.map { $0.makeViewController() }
        switchToGroupIndex()
        switchToOrderIndex()
        let profileVC = (viewControllers?.last as? UINavigationController)?.viewControllers.first as? ProfileViewController
        profileVC?.delegate = self
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
        selectedIndex = 2
        userObject.map {
            groupManager.addUserIntoGroup(groupID: groupID, userID: "\($0.userID)")
        }
    }
    private func switchToOrderIndex() {
        guard let orderID else { return }
        selectedIndex = 3
        userObject.map {
            orderManager.addUserIntoOrderGroup(userID: "\($0.userID)", orderID: orderID)
        }
    }
}

extension TabBarViewController {
    private enum Tab {
        case home
        case favorite
        case vote
        case order
        case profile

        func makeViewController() -> UIViewController {
            let controller: UIViewController
            let userManager = UserManager()
            switch self {
            case .home: controller = UINavigationController(rootViewController: HomeViewController())
            case .favorite: controller = UINavigationController(rootViewController: FavoriteViewController())
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
                return UIImage(systemName: "house")?.setColor(color: .darkBrown)
            case .favorite:
                return UIImage(systemName: "heart")?.setColor(color: .darkBrown)
            case .vote:
                return UIImage(systemName: "hand.tap")?.setColor(color: .darkBrown)
            case .order:
                return UIImage(systemName: "doc.text")?.setColor(color: .darkBrown)
            case .profile:
                return UIImage(systemName: "person")?.setColor(color: .darkBrown)
            }
        }
        private var selectedImage: UIImage? {
            switch self {
            case .home:
                return UIImage(systemName: "house.fill")?.setColor(color: .darkBrown)
            case .favorite:
                return UIImage(systemName: "heart.fill")?.setColor(color: .darkBrown)
            case .vote:
                return UIImage(systemName: "hand.tap.fill")?.setColor(color: .darkBrown)
            case .order:
                return UIImage(systemName: "doc.text.fill")?.setColor(color: .darkBrown)
            case .profile:
                return UIImage(systemName: "person.fill")?.setColor(color: .darkBrown)
            }
        }
    }
}

extension TabBarViewController: ProfileViewControllerDelegate {
    func profileViewControllerDidPressLogOut(_ viewController: ProfileViewController) {
        tabBardelegate?.getProfileViewControllerDidPressLogOut(self)
    }


}
