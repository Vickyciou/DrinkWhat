//
//  VoteNavigationController.swift
//  DrinkWhat
//
//  Created by Vickyciou on 2023/6/18.
//

import UIKit

protocol ShopObjectsAccessible {
    func setShopObjects(_ shopObjects: [ShopObject])
}

protocol VoteResultsAccessible {
    func setVoteResults(_ voteResults: [VoteResult])
}

class VoteNavigationController: UINavigationController {
    private let groupID: String
    private let groupManager = GroupManager()
    private let shopManager = ShopManager()
    private var groupObject: GroupResponse?
    private var shopObjects: [ShopObject] = [] {
        didSet {
            viewControllers.forEach {
                let voteResultsAccessible = $0 as? ShopObjectsAccessible
                voteResultsAccessible?.setShopObjects(shopObjects)
            }
        }
    }
    private var voteResults: [VoteResult] = [] {
        didSet {
            viewControllers.forEach {
                let voteResultsAccessible = $0 as? VoteResultsAccessible
                voteResultsAccessible?.setVoteResults(voteResults)
            }
        }
    }
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

    private func decideVC(
        groupObject: GroupResponse,
        userObject: UserObject,
        voteResults: [VoteResult],
        shopObjects: [ShopObject]
    ) {
        guard isVoted(voteResults: voteResults, userObject: userObject) else {
            if viewControllers.last is NotVotedViewController { return }
            let shopListToVoteVC = NotVotedViewController(groupObject: groupObject)
            shopListToVoteVC.setVoteResults(voteResults)
            shopListToVoteVC.setShopObjects(shopObjects)
            return pushViewController(shopListToVoteVC, animated: !viewControllers.isEmpty)
        }
        if isEndVote(groupObject: groupObject) {
            if viewControllers.last is VoteResultViewController { return }
            let voteResultVC = VoteResultViewController(
                groupObject: groupObject,
                voteResults: voteResults,
                shopObjects: shopObjects
            )
            pushViewController(voteResultVC, animated: !viewControllers.isEmpty)
        } else {
            if viewControllers.last is VotingViewController { return }
            let votingVC = VotingViewController(
                groupObject: groupObject,
                isInitiator: groupObject.initiatorUserID == userObject.userID
            )
            votingVC.setVoteResults(voteResults)
            votingVC.setShopObjects(shopObjects)
            votingVC.delegate = self
            pushViewController(votingVC, animated: !viewControllers.isEmpty)
        }
    }

    private func isVoted(voteResults: [VoteResult], userObject: UserObject) -> Bool {
        voteResults.flatMap { $0.userIDs }.contains(userObject.userID)
    }

    private func isEndVote(groupObject: GroupResponse) -> Bool {
        groupObject.state == "已完成"
    }

    private func isInitiator(groupObject: GroupResponse, userObject: UserObject) -> Bool {
        groupObject.initiatorUserID == userObject.userID
    }
}

extension VoteNavigationController: GroupManagerDelegate {
    func groupManager(_ manager: GroupManager, didGetGroupObject groupObject: GroupResponse) {
        self.groupObject = groupObject
        groupManager.listenVoteResults(inGroup: groupObject.groupID)
    }

    func groupManager(_ manager: GroupManager, didGetVoteResults voteResults: [VoteResult]) {
        let sortedVoteResults = voteResults.sorted(by: {$0.userIDs.count > $1.userIDs.count})
        self.voteResults = sortedVoteResults
        let shopIDs = voteResults.map { $0.shopID }
        shopManager.getShopObjects(shopIDs)
    }
}

extension VoteNavigationController: ShopManagerDelegate {
    func shopManager(_ manager: ShopManager, didGetShopData shopData: [ShopObject]) {
        shopObjects = shopData
        if let groupObject, let userObject {
            decideVC(groupObject: groupObject, userObject: userObject, voteResults: voteResults, shopObjects: shopData)
        }
    }
}

extension VoteNavigationController: VotingViewControllerDelegate {
    func votingViewController(_ vc: VotingViewController, didPressEndVoteButton button: UIButton) {
        groupManager.setVoteStateToFinish(groupID: groupID)
    }
}
