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
    private var shopIDs: [String]?
    private let groupManager = GroupManager()
    private let shopManager = ShopManager()
    private let orderManager = OrderManager()
    private var groupObject: GroupResponse
    private let userObject: UserObject
    private var shopObjects: [ShopObject] = [] {
        didSet {
            viewControllers.forEach {
                let shopObjectsAccessible = $0 as? ShopObjectsAccessible
                shopObjectsAccessible?.setShopObjects(shopObjects)
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

    init(userObject: UserObject, groupID: String, groupObject: GroupResponse) {
        self.userObject = userObject
        self.groupID = groupID
        self.groupObject = groupObject
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
        groupManager.listenGroupObject(groupID: groupID)
    }

    private func decideVC(
        groupObject: GroupResponse,
        userObject: UserObject,
        voteResults: [VoteResult],
        shopObjects: [ShopObject]
    ) {
        if isEndVote(groupObject: groupObject) {
            if viewControllers.last is VoteResultViewController { return }
            let voteResultVC = VoteResultViewController(
                groupObject: groupObject,
                userObject: userObject,
                voteResults: voteResults,
                shopObjects: shopObjects
            )
            if !viewControllers.isEmpty {
                viewControllers.removeLast()
            }

            pushViewController(voteResultVC, animated: !viewControllers.isEmpty)
        } else
        if isVoted(voteResults: voteResults, userObject: userObject) {
            if viewControllers.last is VotingViewController { return }
            let votingVC = VotingViewController(
                groupObject: groupObject,
                isInitiator: groupObject.initiatorUserID == userObject.userID
            )
            votingVC.setVoteResults(voteResults)
            votingVC.setShopObjects(shopObjects)
            votingVC.delegate = self

            if !viewControllers.isEmpty {
                viewControllers.removeLast()
            }

            pushViewController(votingVC, animated: !viewControllers.isEmpty)

        } else {
            if viewControllers.last is NotVotedViewController { return }
            let notVotedVC = NotVotedViewController(
                userObject: userObject,
                groupObject: groupObject,
                isInitiator: groupObject.initiatorUserID == userObject.userID
            )
            notVotedVC.setVoteResults(voteResults)
            notVotedVC.setShopObjects(shopObjects)
            notVotedVC.delegate = self
            return pushViewController(notVotedVC, animated: !viewControllers.isEmpty)
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
        let sortedVoteResults = voteResults.sorted(by: { $0.userIDs.count > $1.userIDs.count })
        self.voteResults = sortedVoteResults
        let shopIDs = sortedVoteResults.map { $0.shopID }
        if shopObjects.map({ $0.id }) == shopIDs {
            decideVC(
                groupObject: groupObject,
                userObject: userObject,
                voteResults: sortedVoteResults,
                shopObjects: shopObjects
            )
        } else {
            shopManager.getShopObjects(shopIDs)
        }
    }
}

extension VoteNavigationController: ShopManagerDelegate {
    func shopManager(_ manager: ShopManager, didGetShopData shopData: [ShopObject]) {
        shopObjects = shopData
        decideVC(groupObject: groupObject, userObject: userObject, voteResults: voteResults, shopObjects: shopObjects)
    }
    func shopManager(_ manager: ShopManager, didFailWith error: Error) {
        print("Decode error in the vote group shops with: \(error)")
    }
}

extension VoteNavigationController: NotVotedViewControllerDelegate {
    func didPressCancelButton(_ vc: NotVotedViewController) {
        cancelGroup(vc: vc)
    }
}

extension VoteNavigationController: VotingViewControllerDelegate {
    func didPressEndVoteButton(_ vc: VotingViewController) {
        guard let voteResult = voteResults.first else { return }
        let winnerShopID = voteResult.shopID
        guard let shop = shopObjects.first(where: { $0.id == winnerShopID }) else {
            return }

        Task {
            do {
                let orderID = try await orderManager.createOrder(
                    shopObject: shop,
                    initiatorUserID: userObject.userID,
                    initiatorUserName: userObject.userName ?? "Name"
                ).orderID
                groupManager.setVoteStatus(groupID: groupID, status: GroupStatus.finished.rawValue)

                let joinUserIDs = groupObject.joinUserIDs
                try await orderManager.addUsers(
                    userIDs: joinUserIDs,
                    toJoinOrder: orderID
                )

            } catch OrderManagerError.itemAlreadyExistsError {
                let alert = UIAlertController(
                    title: "開團失敗",
                    message: "目前已有進行中的團購群組囉！\n請先完成進行中的群組~",
                    preferredStyle: .alert
                )
                let okAction = UIAlertAction(title: "OK", style: .default)
                alert.addAction(okAction)
                present(alert, animated: true)
            }
        }
    }
    func didPressCancelButton(_ vc: VotingViewController) {
        cancelGroup(vc: vc)
    }
}
extension VoteNavigationController {
    func cancelGroup(vc: UIViewController) {
        let alert = UIAlertController(
            title: "取消投票",
            message: "確定要取消此投票群組嗎？",
            preferredStyle: .alert
        )
        let confirmAction = UIAlertAction(title: "確定", style: .default) { [self]_ in
            groupManager.setVoteStatus(groupID: groupID, status: GroupStatus.canceled.rawValue)
            vc.dismiss(animated: true)
        }
        let cancelAction = UIAlertAction(title: "先不要", style: .cancel)
        alert.addAction(confirmAction)
        alert.addAction(cancelAction)
        present(alert, animated: true)
    }
}
