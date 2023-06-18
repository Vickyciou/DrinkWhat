//
//  VoteResultViewController.swift
//  DrinkWhat
//
//  Created by Vickyciou on 2023/6/18.
//

import UIKit

class VoteResultViewController: UIViewController {
    private let winnerShopView = WinnerShopView(frame: .zero)
    private lazy var tableView: UITableView = makeTableView()
    private lazy var startOrderButton: UIButton = makeStartOrderButton()
    private let voteManager = VoteManager()
    private var voteObject: VoteObject?

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
        setupWinnerShopView()
        setupTableView()
        setupStartOrderButton()
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
    private func setupWinnerShopView() {
        winnerShopView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(winnerShopView)
        NSLayoutConstraint.activate([
            winnerShopView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            winnerShopView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            winnerShopView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)])
        guard let voteResultOfWinner = voteObject?.voteResult.first else { return }
        winnerShopView.setupWinnerView(shopImage: UIImage(systemName: "bag"),
                                       shopName: voteResultOfWinner.shopObject.name,
                                       numberOfVotes: voteResultOfWinner.voteUsersID.count)
    }

    private func setupTableView() {
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: winnerShopView.bottomAnchor, constant: 70),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 40),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -40)
        ])
    }
    private func setupStartOrderButton() {
        view.addSubview(startOrderButton)
        NSLayoutConstraint.activate([
            startOrderButton.topAnchor.constraint(equalTo: tableView.bottomAnchor, constant: 20),
            startOrderButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            startOrderButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            startOrderButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20)
        ])
        startOrderButton.layer.cornerRadius = 10
        startOrderButton.layer.masksToBounds = true
    }
}
extension VoteResultViewController {

    private func makeTableView() -> UITableView {
        let tableView = UITableView(frame: .zero)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.register(VoteResultCell.self, forCellReuseIdentifier: "VoteResultCell")
        tableView.contentInsetAdjustmentBehavior = .never
//        tableView.separatorStyle = .none
        tableView.allowsSelection = false
        return tableView
    }
    private func makeStartOrderButton() -> UIButton {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(UIColor.lightBrown, for: .normal)
        button.setTitleColor(UIColor.midiumBrown, for: .highlighted)
        button.titleLabel?.font = .medium(size: 18)
        button.backgroundColor = UIColor.darkBrown
        button.setTitle("前往點餐", for: .normal)
        button.addTarget(self, action: #selector(startOrderButtonTapped(_:)), for: .touchUpInside)
        return button
    }
    @objc func startOrderButtonTapped(_ sender: UIButton) {
        // setData給firestore
    }
}

extension VoteResultViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let voteObject = voteObject else { fatalError("There is no voteObject in numberOfRowsInSection") }
        return voteObject.voteResult.count - 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "VoteResultCell", for: indexPath)
                as? VoteResultCell else { fatalError("Cannot created VoteCell") }
        guard let voteObject = voteObject else { fatalError("There is no voteObject in cellForRowAt") }
        let voteResults = voteObject.voteResult[indexPath.row + 1]
        cell.setupVoteCell(
            shopName: voteResults.shopObject.name,
            numberOfVote: voteResults.voteUsersID.count
        )
        return cell
    }
}

extension VoteResultViewController: VoteObjectProvider {
    func receiveVoteObject(_ voteObject: VoteObject) {
        self.voteObject = voteObject
        tableView.reloadData()
    }
}
