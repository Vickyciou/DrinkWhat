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
    private let groupObject: GroupResponse
    private let userObject: UserObject
    private let shopObjects: [ShopObject]
    private let voteResults: [VoteResult]
    private let orderManager = OrderManager()

    init(
        groupObject: GroupResponse,
        userObject: UserObject,
        voteResults: [VoteResult],
        shopObjects: [ShopObject]
    ) {
        self.groupObject = groupObject
        self.userObject = userObject
        self.voteResults = voteResults
        self.shopObjects = shopObjects
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
        navigationItem.title = "由\(groupObject.initiatorUserName)發起的投票"
        tabBarController?.tabBar.backgroundColor = .white
        navigationItem.hidesBackButton = true
        let closeImage = UIImage(systemName: "xmark")?
            .withConfiguration(UIImage.SymbolConfiguration(pointSize: 20))
            .withTintColor(UIColor.darkBrown)
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
        guard let voteResult = voteResults.first else { return }
        let winnerShopID = voteResult.shopID
        guard let shop = shopObjects.first(where: { $0.id == winnerShopID }) else { return }
        winnerShopView.setupWinnerView(
            shopImageURL: shop.logoImageURL,
            shopName: shop.name,
            numberOfVotes: voteResult.userIDs.count
        )
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
        button.setTitle("開始團購", for: .normal)
        button.addTarget(self, action: #selector(startOrderButtonTapped(_:)), for: .touchUpInside)
        return button
    }
    @objc func startOrderButtonTapped(_ sender: UIButton) {

        guard let voteResult = voteResults.first else { return }
        let winnerShopID = voteResult.shopID
        guard let shop = shopObjects.first(where: { $0.id == winnerShopID }) else { return }
        Task {
            do {
                let orderID = try await orderManager.createOrder(shopObject: shop,
                                                                initiatorUserID: groupObject.initiatorUserID,
                                                                initiatorUserName: groupObject.initiatorUserName).orderID
                try await orderManager.addUserIntoOrderGroup(userID: userObject.userID, orderID: orderID)
                let shopMenuVC = ShopMenuViewController(shopObject: shop)
                present(shopMenuVC, animated: true)
            } catch ManagerError.itemAlreadyExistsError {
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
}

extension VoteResultViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        voteResults.count - 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "VoteResultCell", for: indexPath)
                as? VoteResultCell else { fatalError("Cannot created VoteResultCell") }
        let voteResult = voteResults[indexPath.row + 1]
        let shopID = voteResult.shopID
        guard let shop = shopObjects.first(where: { $0.id == shopID }) else { return cell }
        cell.setupVoteCell(
            shopName: shop.name,
            numberOfVote: voteResult.userIDs.count
        )
        return cell
    }
}
