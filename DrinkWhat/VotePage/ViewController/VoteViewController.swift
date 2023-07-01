//
//  VoteViewController.swift
//  DrinkWhat
//
//  Created by Vickyciou on 2023/6/15.
//

import UIKit

class VoteViewController: UIViewController {
    private lazy var tableView: UITableView = makeTableView()
    private let groupManager = GroupManager()
    private var userObject: UserObject? {
        UserManager.shared.userObject
    }
    private var groupObjects: [GroupResponse] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        setupVC()
    }
    private func setupVC() {
        setNavController()
        setupTableView()
        guard let userObject = userObject else { return }
        groupManager.listenGroupChangeEvent(userID: userObject.userID)
        groupManager.delegate = self
    }
    private func setNavController() {
        navigationItem.title = "投票首頁"
        tabBarController?.tabBar.backgroundColor = .white
    }
    private func setupTableView() {
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}

extension VoteViewController {
    private func makeTableView() -> UITableView {
        let tableView = UITableView(frame: .zero)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(VoteCell.self, forCellReuseIdentifier: "VoteCell")
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.separatorStyle = .none
        return tableView
    }
}

extension VoteViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let continueVotes = groupObjects.filter({ $0.state == "進行中" })
        let finishedVotes = groupObjects.filter({ $0.state == "已完成" })
        switch section {
        case 0:
            return continueVotes.count
        case 1:
            return finishedVotes.count
        default:
            return 0
        }

    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "VoteCell", for: indexPath) as? VoteCell
        else { fatalError("Cannot created VoteCell") }
        let continueVotes = groupObjects.filter({ $0.state == "進行中" })
        let finishedVotes = groupObjects.filter({ $0.state == "已完成" })


        switch indexPath.section {
        case 0:
            let continueVotes = continueVotes[indexPath.row]
            let date = Date(timeIntervalSince1970: continueVotes.date)
            let dateString = date.dateToString(date: date)
            cell.setupVoteCell(profileImageURL: continueVotes.initiatorUserImage,
                               userName: continueVotes.initiatorUserName,
                               voteState: continueVotes.state,
                               date: dateString)
            return cell
        case 1:
            let finishedVotes = finishedVotes[indexPath.row]
            let date = Date(timeIntervalSince1970: finishedVotes.date)
            let dateString = date.dateToString(date: date)
            cell.setupVoteCell(profileImageURL: finishedVotes.initiatorUserImage,
                               userName: finishedVotes.initiatorUserName,
                               voteState: finishedVotes.state,
                               date: dateString)
            return cell
        default:
            return cell
        }
    }
}

extension VoteViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let voteNavigationVC = VoteNavigationController(groupID: groupObjects[indexPath.row].groupID)
        present(voteNavigationVC, animated: true)
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "進行中的投票"
        case 1:
            return "已完成的投票"
        default:
            return ""
        }
    }
}
extension VoteViewController: GroupManagerDelegate {
    func groupManager(_ manager: GroupManager, didGetAllGroupData groupData: [GroupResponse]) {
        let sortedGroupData = groupData.sorted(by: { $0.date > $1.date })
        self.groupObjects = sortedGroupData
        tableView.reloadData()
    }
}
