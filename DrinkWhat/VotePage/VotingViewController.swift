//
//  VotingViewController.swift
//  DrinkWhat
//
//  Created by Vickyciou on 2023/6/17.
//

import UIKit

class VotingViewController: UIViewController {
    private lazy var tableView: UITableView = makeTableView()
    private lazy var submitButton: UIButton = makeSubmitButton()
    private let voteManager = VoteManager()
    private var voteObject: VoteObject?
    var isIntiator: Bool = false

    let roomID: String

    init(roomID: String) {
        self.roomID = roomID
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
        setupSubmitButton()
        if isIntiator == false { submitButton.isHidden = true }
//        getData(roomID: roomID)
    }
    private func setNavController() {
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = UIColor.white
        appearance.titleTextAttributes = [.foregroundColor: UIColor.darkBrown ?? .black]
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.darkBrown ?? .black]
        appearance.shadowColor = UIColor.clear
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationItem.title = "Name發起的投票"
        tabBarController?.tabBar.backgroundColor = .white
        navigationItem.hidesBackButton = true
    }
    private func setupTableView() {
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
    }
    private func setupSubmitButton() {
        view.addSubview(submitButton)
        NSLayoutConstraint.activate([
            submitButton.topAnchor.constraint(equalTo: tableView.bottomAnchor, constant: 20),
            submitButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            submitButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            submitButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20)
        ])
    }
//    private func getData(roomID: String) {
//        voteManager.getDataFromVoteObject(roomID: roomID) { [weak self] result in
//            switch result {
//            case .success(let data):
//                self?.voteObject = data
//                self?.tableView.reloadData()
//            case .failure(let error):
//                print("Get voteObject發生錯誤: \(error)")
//            }
//        }
//    }
}
extension VotingViewController {
    private func makeTableView() -> UITableView {
        let tableView = UITableView(frame: .zero)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.register(VotingCell.self, forCellReuseIdentifier: "VotingCell")
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
        return tableView
    }
    private func makeSubmitButton() -> UIButton {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(UIColor.lightBrown, for: .normal)
        button.setTitleColor(UIColor.midiumBrown, for: .highlighted)
        button.titleLabel?.font = .medium(size: 18)
        button.backgroundColor = UIColor.darkBrown
        button.setTitle("結束投票", for: .normal)
        return button
    }
}

extension VotingViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        voteObject?.voteResult.count ?? 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "VotingCell", for: indexPath)
                as? VotingCell else { fatalError("Cannot created VotingCell") }
        guard let voteObject = voteObject else { fatalError("There is no voteObject") }
        let shop = voteObject.voteResult[indexPath.row]
        cell.setupVoteCell(
            shopImage: UIImage(systemName: "bag"),
            shopName: shop.shopObject.name,
            numberOfVote: shop.voteUsersID.count
        )
        return cell
    }
}

extension VotingViewController: VoteObjectProvider {
    func receiveVoteObject(_ voteObject: VoteObject) {
        self.voteObject = voteObject
        tableView.reloadData()
    }
}
