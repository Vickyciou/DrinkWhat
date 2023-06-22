//
//  VoteViewController.swift
//  DrinkWhat
//
//  Created by Vickyciou on 2023/6/15.
//

import UIKit

class VoteViewController: UIViewController {
    private lazy var tableView: UITableView = makeTableView()
    private var voteList: [VoteList] = []
    private let voteManager = VoteManager()
    private let myInfo = UserObject(userID: "UUID1", userName: "Vicky", userImageURL: "", groupIDs: [], orderIDs: [], favoriteShops: [])

    override func viewDidLoad() {
        super.viewDidLoad()
        setupVC()
    }
    private func setupVC() {
        setNavController()
        setupTableView()
        getVoteListData()
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
    private func getVoteListData() {
        voteManager.getDataFromVoteList { result in
            switch result {
            case .success(let data):
                let sortData = data.sorted { $0.date > $1.date }
                self.voteList = sortData
                tableView.reloadData()
            case .failure(let error):
                print("Get voteList發生錯誤: \(error)")
            }
        }
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
//        tableView.allowsSelection = false
        return tableView
    }
}

extension VoteViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        voteList.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "VoteCell", for: indexPath) as? VoteCell
        else { fatalError("Cannot created VoteCell") }
        let voteList = voteList[indexPath.row]
        let date = Date(timeIntervalSince1970: voteList.date)
        let dateString = date.dateToString(date: date)
        cell.setupVoteCell(profileImage: UIImage(systemName: "person.circle.fill")?.setColor(color: .darkBrown),
                           userName: voteList.userObject.userName,
                           voteState: voteList.state,
                           date: dateString)
        return cell
    }
}

// 這邊要寫section header
extension VoteViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let voteNavigationVC = VoteNavigationController(roomID: voteList[indexPath.row].roomID)
        present(voteNavigationVC, animated: true)
    }
}
