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
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        groupObjects.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "VoteCell", for: indexPath) as? VoteCell
        else { fatalError("Cannot created VoteCell") }
        let voteList = groupObjects[indexPath.row]
        let date = Date(timeIntervalSince1970: voteList.date)
        let dateString = date.dateToString(date: date)
        cell.setupVoteCell(profileImageURL: voteList.initiatorUserImage,
                           userName: voteList.initiatorUserName,
                           voteState: voteList.state,
                           date: dateString)
        return cell
    }
}

// 這邊要寫section header
extension VoteViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let voteNavigationVC = VoteNavigationController(groupID: groupObjects[indexPath.row].groupID)
        present(voteNavigationVC, animated: true)
    }
}
extension VoteViewController: GroupManagerDelegate {
    func groupManager(_ manager: GroupManager, didGetAllGroupData groupData: [GroupResponse]) {
        self.groupObjects = groupData
        tableView.reloadData()
    }
}
