//
//  VoteNavigationController.swift
//  DrinkWhat
//
//  Created by Vickyciou on 2023/6/18.
//

import UIKit

class VoteNavigationController: UINavigationController {

    private let groupID: String
    private let groupManager = GroupManager()
    private var shopManager = ShopManager()
    private var groupObject: GroupResponse?
    private var shopObjects: [ShopObject] = []
    private let userObject = UserManager.shared.userObject

    init(groupID: String) {
        self.groupID = groupID
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationItem.hidesBackButton = true
        groupManager.delegate = self
        shopManager.delegate = self
        groupManager.getGroupObject(groupID: groupID)
    }

    private func decideVC(groupObject: GroupResponse, userObject: UserObject) {
        guard isVote(groupObject: groupObject, userObject: userObject) else {
            if viewControllers.last is NotVotedViewController {
                print("is NotVotedViewController")
                return
            }
            print("NotVotedViewController")
            let shopListToVoteVC = NotVotedViewController(groupObject: groupObject, shopObjects: shopObjects)
            return pushViewController(shopListToVoteVC, animated: true)
        }
        if isEndVote(groupObject: groupObject) {
            if viewControllers.last is VoteResultViewController {
                print("is VoteResultViewController")
                return
            }
            print("VoteResultViewController")
            pushViewController(VoteResultViewController(groupObject: groupObject, shopObjects: shopObjects), animated: true)
        } else {
            if viewControllers.last is VotingViewController {
                print("is VotingViewController")
                return
            }
            print("VotingViewController")
            let votingVC = VotingViewController(groupObject: groupObject, shopObjects: shopObjects)
            votingVC.isIntiator = groupObject.initiatorUserID == userObject.userID
            pushViewController(votingVC, animated: true)
        }

    }
    private func isVote(groupObject: GroupResponse, userObject: UserObject) -> Bool {
        groupObject
            .voteResults
            .flatMap { $0.voteUserIDs }
            .contains(userObject.userID)
    }
    private func isEndVote(groupObject: GroupResponse) -> Bool {
        guard groupObject.state == "已完成" else { return false }
        return true
    }

    private func isIntiator(groupObject: GroupResponse, userObject: UserObject) -> Bool {
        groupObject.initiatorUserID == userObject.userID
    }

    private func getShopObject(groupObject: GroupResponse) {
        let shopID = groupObject.voteResults.map({ $0.shopID })
        shopID.forEach({ shopManager.getShopObject(shopID: $0) })
    }
}
extension VoteNavigationController: GroupManagerDelegate {
    func groupManager(_ manager: GroupManager, didGetGroupObject groupObject: GroupResponse) {
        self.groupObject = groupObject
        getShopObject(groupObject: groupObject)
    }
}
extension VoteNavigationController: ShopManagerDelegate {
    func shopManager(_ manager: ShopManager, didGetShopObject shopObject: ShopObject) {
        self.shopObjects.append(shopObject)
        guard let userObject = userObject, let groupObject else { return }
        self.decideVC(groupObject: groupObject, userObject: userObject)
    }
}
