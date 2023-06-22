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
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        navigationController?.setNavigationBarHidden(false, animated: animated)
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
                return UIImage(systemName: "house")?.setColor(color: .darkBrown)
            case .favorite:
                return UIImage(systemName: "heart")?.setColor(color: .darkBrown)
            case .vote:
                return UIImage(systemName: "hand.tap")?.setColor(color: .darkBrown)
            case .order:
                return UIImage(systemName: "list.bullet.clipboard")?.setColor(color: .darkBrown)
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
                return UIImage(systemName: "list.bullet.clipboard.fill")?.setColor(color: .darkBrown)
            case .profile:
                return UIImage(systemName: "person.fill")?.setColor(color: .darkBrown)
            }
        }
    }
}
