//
//  TabBarViewController.swift
//  DrinkWhat
//
//  Created by Vickyciou on 2023/6/15.
//

import UIKit

class TabBarViewController: UITabBarController {
    private let tabs: [Tab] = [.home, .favorite, .vote, .order, .profile]

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        viewControllers = tabs.map { $0.makeViewController() }
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
                return UIImage(systemName: "house")
            case .favorite:
                return UIImage(systemName: "heart")
            case .vote:
                return UIImage(systemName: "hand.tap")
            case .order:
                return UIImage(systemName: "list.bullet.clipboard")
            case .profile:
                return UIImage(systemName: "person")
            }
        }
        private var selectedImage: UIImage? {
            switch self {
            case .home:
                return UIImage(systemName: "house.fill")
            case .favorite:
                return UIImage(systemName: "heart.fill")
            case .vote:
                return UIImage(systemName: "hand.tap.fill")
            case .order:
                return UIImage(systemName: "list.bullet.clipboard.fill")
            case .profile:
                return UIImage(systemName: "person.fill")
            }
        }
    }
}
