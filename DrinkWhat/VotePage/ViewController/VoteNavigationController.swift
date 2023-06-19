//
//  VoteNavigationController.swift
//  DrinkWhat
//
//  Created by Vickyciou on 2023/6/18.
//

import UIKit

protocol VoteObjectProvider {
    func receiveVoteObject(_ voteObject: VoteObject)
}

class VoteNavigationController: UINavigationController {

    private let voteManager = VoteManager()
    private let roomID: String
    private var voteObject: VoteObject?
    private let myInfo = UserObject(userID: "UUID1", userName: "Vicky", userImageURL: "http://image.com")

    init(roomID: String) {
        self.roomID = roomID
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationItem.hidesBackButton = true
        getData(roomID: roomID)
    }

    private func getData(roomID: String) {
        voteManager.getDataFromVoteObject(roomID: roomID) { [weak self] result in
            switch result {
            case .success(var data):
                data.voteResults.sort(by: { $0.voteUsersIDs.count > $1.voteUsersIDs.count })
                self?.voteObject = data
                self?.decideVC(voteObject: data)
                self?.viewControllers
                    .compactMap { $0 as? VoteObjectProvider }
                    .forEach { $0.receiveVoteObject(data) }
            case .failure(let error):
                print("Get voteObject發生錯誤: \(error)")
            }
        }
    }
    private func decideVC(voteObject: VoteObject) {
        guard isVote(voteObject: voteObject) else {
            if viewControllers.last is NotVotedViewController {
                print("is NotVotedViewController")
                return
            }
            print("NotVotedViewController")
            let shopListToVoteVC = NotVotedViewController(roomID: roomID)
            shopListToVoteVC.receiveVoteObject(voteObject)
            return pushViewController(shopListToVoteVC, animated: true)
        }
        if isEndVote(voteObject: voteObject) {
            if viewControllers.last is VoteResultViewController {
                print("is VoteResultViewController")
                return
            }
            print("VoteResultViewController")
            pushViewController(VoteResultViewController(roomID: roomID), animated: true)
        } else {
            if viewControllers.last is VotingViewController {
                print("is VotingViewController")
                return
            }
            print("VotingViewController")
            let votingVC = VotingViewController(roomID: roomID)
            votingVC.receiveVoteObject(voteObject)
            votingVC.isIntiator = voteObject.initiatorUserID == myInfo.userID
            pushViewController(votingVC, animated: true)
        }

    }
    private func isVote(voteObject: VoteObject) -> Bool {
        voteObject
            .voteResults
            .flatMap { $0.voteUsersIDs }
            .contains(myInfo.userID)
    }
    private func isEndVote(voteObject: VoteObject) -> Bool {
        guard voteObject.state == "已完成" else { return false }
        return true
    }

    private func isIntiator(voteObject: VoteObject) -> Bool {
        voteObject.initiatorUserID == myInfo.userID
    }
}
