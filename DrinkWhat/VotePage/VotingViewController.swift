//
//  VotingViewController.swift
//  DrinkWhat
//
//  Created by Vickyciou on 2023/6/17.
//

import UIKit

class VotingViewController: UIViewController {
    private lazy var tableView: UITableView = makeTableView()
    private lazy var endVoteButton: UIButton = makeEndVoteButton()
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
        if isIntiator == false { endVoteButton.isHidden = true }
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
        let closeImage = UIImage(systemName: "xmark")?
            .withConfiguration(UIImage.SymbolConfiguration(pointSize: 20))
            .withTintColor(UIColor.darkBrown ?? .black)
            .withRenderingMode(.alwaysOriginal)
        let closeButton = UIBarButtonItem(image: closeImage,
                                          style: .plain,
                                          target: self,
                                          action: #selector(closeButtonTapped))
        navigationItem.setRightBarButton(closeButton, animated: false)
    }
    @objc private func closeButtonTapped() {
        dismiss(animated: true)
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
        view.addSubview(endVoteButton)
        NSLayoutConstraint.activate([
            endVoteButton.topAnchor.constraint(equalTo: tableView.bottomAnchor, constant: 20),
            endVoteButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            endVoteButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            endVoteButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20)
        ])
        endVoteButton.layer.cornerRadius = 10
        endVoteButton.layer.masksToBounds = true
    }
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
    private func makeEndVoteButton() -> UIButton {
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
