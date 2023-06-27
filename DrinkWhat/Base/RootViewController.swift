//
//  RootViewController.swift
//  DrinkWhat
//
//  Created by Vickyciou on 2023/6/27.
//

import UIKit

class RootViewController: UIViewController {

    private var showLoginView: Bool = false
    var url: URL?

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
        func decideVC() async throws {
            if showLoginView == false {
                try await UserManager.shared.loadCurrentUser()
                guard let url = url else {
                    show(TabBarViewController(), sender: nil)
                    return
                }
                let tabBarVC = handleShareURL(url)
                show(tabBarVC, sender: nil)
            } else {
                show(LoginViewController(), sender: nil)
            }
        }

        func handleShareURL(_ url: URL) -> UIViewController {
            if url.host == "share" {
                if let groupID = url.queryParameters?["groupID"] {
                    return TabBarViewController(groupID: groupID)
                }
            }
            return UIViewController()
        }

    }
}
