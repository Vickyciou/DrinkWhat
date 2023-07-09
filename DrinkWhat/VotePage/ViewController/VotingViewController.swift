//
//  VotingViewController.swift
//  DrinkWhat
//
//  Created by Vickyciou on 2023/6/17.
//

import UIKit

protocol VotingViewControllerDelegate: AnyObject {
    func votingViewController(_ vc: VotingViewController, didPressEndVoteButton button: UIButton)
}

class VotingViewController: UIViewController {
    private lazy var tableView: UITableView = makeTableView()
    private lazy var endVoteButton: UIButton = makeEndVoteButton()
    private var groupObject: GroupResponse
    private var voteResults: [VoteResult] = []
    private var shopObjects: [ShopObject] = []
    private let isInitiator: Bool
    weak var delegate: VotingViewControllerDelegate?

    init(
        groupObject: GroupResponse,
        isInitiator: Bool
    ) {
        self.groupObject = groupObject
        self.isInitiator = isInitiator
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
        if isInitiator == false { endVoteButton.isHidden = true }
    }
    private func setNavController() {
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = UIColor.white
        appearance.titleTextAttributes = [.foregroundColor: UIColor.darkLogoBrown]
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.darkLogoBrown]
        appearance.shadowColor = UIColor.clear
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
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
        view.addSubview(endVoteButton)
        NSLayoutConstraint.activate([
            endVoteButton.topAnchor.constraint(equalTo: tableView.bottomAnchor, constant: 20),
            endVoteButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            endVoteButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            endVoteButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            endVoteButton.heightAnchor.constraint(equalToConstant: 44)
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
        let normalBackground = UIColor.darkLogoBrown.toImage()
        let selectedBackground = UIColor.darkLogoBrown.withAlphaComponent(0.7).toImage()
        button.setBackgroundImage(normalBackground, for: .normal)
        button.setBackgroundImage(selectedBackground, for: .highlighted)
        button.titleLabel?.font = .medium2()
        button.setTitleColor(UIColor.white, for: .normal)
        button.setTitle("結束投票", for: .normal)
        button.addTarget(self, action: #selector(endVoteButtonTapped), for: .touchUpInside)
        return button
    }
    @objc func endVoteButtonTapped() {
        delegate?.votingViewController(self, didPressEndVoteButton: endVoteButton)
    }
}

extension VotingViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        voteResults.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "VotingCell", for: indexPath)
                as? VotingCell else { fatalError("Cannot created VotingCell") }
        let voteResult = voteResults[indexPath.row]
        let shopID = voteResult.shopID
        guard let shop = shopObjects.first(where: { $0.id == shopID }) else { return cell }
        cell.setupVoteCell(
            number: "\(indexPath.row + 1)",
            shopImageURL: shop.logoImageURL,
            shopName: shop.name,
            numberOfVote: voteResult.userIDs.count
        )
        return cell
    }
}

extension VotingViewController: VoteResultsAccessible {
    func setVoteResults(_ voteResults: [VoteResult]) {
        self.voteResults = voteResults
        tableView.reloadData()
    }
}

extension VotingViewController: ShopObjectsAccessible {
    func setShopObjects(_ shopObjects: [ShopObject]) {
        self.shopObjects = shopObjects
        tableView.reloadData()
    }
}
