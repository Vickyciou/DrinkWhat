//
//  ShopListToVoteViewController.swift
//  DrinkWhat
//
//  Created by Vickyciou on 2023/6/16.
//

import UIKit

class NotVotedViewController: UIViewController {
    private lazy var tableView: UITableView = makeTableView()
    private lazy var submitButton: UIButton = makeSubmitButton()
    private let groupObject: GroupResponse
    private var shopObjects: [ShopObject] = []
    private var newVoteResults: [(voteResult: VoteResult, isSelected: Bool)] = []
    private let groupManager = GroupManager()
    private let userObject = UserManager.shared.userObject

    init(groupObject: GroupResponse) {
        self.groupObject = groupObject
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
        submitButton.layer.cornerRadius = 10
        submitButton.layer.masksToBounds = true
    }

}
extension NotVotedViewController {
    private func makeTableView() -> UITableView {
        let tableView = UITableView(frame: .zero)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.register(NotVotedCell.self, forCellReuseIdentifier: "ShopListToVoteCell")
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
        button.setTitle("確認送出", for: .normal)
        button.addTarget(self, action: #selector(submitButtonTapped(_:)), for: .touchUpInside)
        return button
    }
    @objc func submitButtonTapped(_ sender: UIButton) {
        guard let selectedShop = newVoteResults.first(where: { $0.isSelected == true }),
              let userObject = userObject else { return }
        groupManager.addVoteResults(
            groupID: groupObject.groupID,
            shopID: selectedShop.voteResult.shopID,
            userID: userObject.userID
        )
    }
}

extension NotVotedViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        newVoteResults.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ShopListToVoteCell", for: indexPath)
                as? NotVotedCell else { fatalError("Cannot created VoteCell") }
        let voteResult = newVoteResults[indexPath.row].voteResult
        let shopID = voteResult.shopID
        guard let shop = shopObjects.first(where: { $0.id == shopID }) else { return cell }
        cell.setupVoteCell(
            shopImageURL: shop.logoImageURL,
            shopName: shop.name,
            numberOfVote: voteResult.userIDs.count
        )
        cell.delegate = self
        cell.chooseButton.isSelected = newVoteResults[indexPath.row].isSelected
        return cell
    }
}

extension NotVotedViewController: NotVotedCellDelegate {
    func didPressedViewMenuButton(_ cell: NotVotedCell, button: UIButton) {
        print("ViewMenu")
    }

    func didSelectedChooseButton(_ cell: NotVotedCell, button: UIButton) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        newVoteResults.indices.forEach { newVoteResults[$0].isSelected = false }
        newVoteResults[indexPath.row].isSelected = true
        tableView.reloadData()
    }
}

extension NotVotedViewController: VoteResultsAccessible {
    func setVoteResults(_ voteResults: [VoteResult]) {
        newVoteResults = voteResults.map { voteResult in
            let first = newVoteResults.first { (tempVoteResult, _) in
                tempVoteResult == voteResult
            }
            let isSelected = first?.isSelected ?? false
            return (voteResult, isSelected)
        }
        tableView.reloadData()
    }
}

extension NotVotedViewController: ShopObjectsAccessible {
    func setShopObjects(_ shopObjects: [ShopObject]) {
        self.shopObjects = shopObjects
        tableView.reloadData()
    }
}
