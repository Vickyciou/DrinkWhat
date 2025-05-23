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
//    private var userManager: UserManager
    private var userObject: UserObject
    private var groupObjects: [GroupResponse] = []
//    private var groupObjects2: [GroupResponse] = []
    init(userObject: UserObject) {
        self.userObject = userObject
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setupVC()
    }
    private func setupVC() {
        view.backgroundColor = .white
        setNavController()
        setupTableView()
        groupManager.listenGroupChangeEvent(userID: userObject.userID)
        groupManager.delegate = self
    }
    private func setNavController() {
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = UIColor.white
        appearance.titleTextAttributes = [.foregroundColor: UIColor.darkLogoBrown]
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.darkLogoBrown]
        appearance.shadowColor = UIColor.clear
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationItem.hidesBackButton = true

        navigationItem.title = "投票首頁"
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
        switch section {
        case 0:
            let continueVotes = groupObjects.filter({ $0.state == GroupStatus.active.rawValue })
            return continueVotes.count
        case 1:
            let finishedVotes = groupObjects.filter {
                $0.state == GroupStatus.canceled.rawValue || $0.state == GroupStatus.finished.rawValue
            }
            return finishedVotes.count
        default:
            return 0
        }

    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "VoteCell", for: indexPath) as? VoteCell
        else { fatalError("Cannot created VoteCell") }

        switch indexPath.section {
        case 0:
            let continueVotes = groupObjects.filter({ $0.state == GroupStatus.active.rawValue })
            let continueVote = continueVotes[indexPath.row]
            let date = Date(timeIntervalSince1970: continueVote.date)
            let dateString = date.dateToString(date: date)
            cell.setupVoteCell(
                profileImageURL: continueVote.initiatorUserImage,
                userName: continueVote.initiatorUserName,
                voteState: continueVote.state,
                date: dateString
            )
            return cell
        case 1:
            let finishedVotes = groupObjects.filter({
                $0.state == GroupStatus.canceled.rawValue || $0.state == GroupStatus.finished.rawValue })
            let finishedVote = finishedVotes[indexPath.row]
            let date = Date(timeIntervalSince1970: finishedVote.date)
            let dateString = date.dateToString(date: date)
            cell.setupVoteCell(
                profileImageURL: finishedVote.initiatorUserImage,
                               userName: finishedVote.initiatorUserName,
                               voteState: finishedVote.state,
                               date: dateString
            )
            return cell
        default:
            return cell
        }
    }
}

extension VoteViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            let continueVotes = groupObjects.filter({ $0.state == GroupStatus.active.rawValue })
            let voteNavigationVC = VoteNavigationController(
                userObject: userObject,
                groupID: continueVotes[indexPath.row].groupID,
                groupObject: continueVotes[indexPath.row]
            )
            present(voteNavigationVC, animated: true)
        case 1:
            let finishedVotes = groupObjects.filter({
                $0.state == GroupStatus.canceled.rawValue ||
                $0.state == GroupStatus.finished.rawValue
            })
            let voteNavigationVC = VoteNavigationController(
                userObject: userObject,
                groupID: finishedVotes[indexPath.row].groupID,
                groupObject: finishedVotes[indexPath.row]
            )
            present(voteNavigationVC, animated: true)
        default:
            return
        }
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
