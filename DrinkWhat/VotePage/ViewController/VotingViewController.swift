//
//  VotingViewController.swift
//  DrinkWhat
//
//  Created by Vickyciou on 2023/6/17.
//

import UIKit

protocol VotingViewControllerDelegate: AnyObject {
    func didPressEndVoteButton(_ vc: VotingViewController)
    func didPressCancelButton(_ vc: VotingViewController)
}

class VotingViewController: UIViewController {
    private lazy var tableView: UITableView = makeTableView()
    private lazy var endVoteButton: UIButton = makeEndVoteButton()
    private var groupObject: GroupResponse
    private var voteResults: [VoteResult] = []
    private var shopObjects: [ShopObject] = []
    private lazy var cancelLabel: UILabel = makeLabel()
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
        setupEndVoteButton()
        if !isInitiator { endVoteButton.isHidden = true }
        if groupObject.state == GroupStatus.canceled.rawValue {
            endVoteButton.isHidden = true
            setupCancelLabel()
        }

    }
    private func setNavController() {
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = UIColor.white
        appearance.titleTextAttributes = [.foregroundColor: UIColor.darkLogoBrown]
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.darkLogoBrown]
        appearance.shadowColor = UIColor.clear
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationItem.title = "\(groupObject.initiatorUserName)發起的投票"
        tabBarController?.tabBar.backgroundColor = .white
        navigationItem.hidesBackButton = true
        let closeImage = UIImage(systemName: "xmark")?
            .withConfiguration(UIImage.SymbolConfiguration(pointSize: 16))
            .withTintColor(UIColor.darkLogoBrown)
            .withRenderingMode(.alwaysOriginal)
        let shareImage = UIImage(systemName: "square.and.arrow.up")?
            .withConfiguration(UIImage.SymbolConfiguration(pointSize: 16))
            .setColor(color: .darkLogoBrown)
        let trashImage = UIImage(systemName: "trash")?
            .setColor(color: .darkLogoBrown)
            .withConfiguration(UIImage.SymbolConfiguration(pointSize: 16))
        let closeButton = UIBarButtonItem(image: closeImage,
                                          style: .plain,
                                          target: self,
                                          action: #selector(closeButtonTapped))
        let shareButton = UIBarButtonItem(image: shareImage,
                                          style: .plain,
                                          target: self,
                                          action: #selector(shareButtonTapped))
        let cancelButton = UIBarButtonItem(image: trashImage,
                                           style: .plain,
                                          target: self,
                                          action: #selector(cancelButtonTapped))

        navigationItem.setRightBarButtonItems([closeButton, shareButton], animated: false)

        if !isInitiator ||
            groupObject.state == GroupStatus.canceled.rawValue ||
            groupObject.state == GroupStatus.finished.rawValue {
            navigationItem.leftBarButtonItem = nil
        } else {
            navigationItem.setLeftBarButton(cancelButton, animated: false)
        }

    }
    @objc private func closeButtonTapped() {
        dismiss(animated: true)
    }

    @objc private func shareButtonTapped() {
        let groupID = groupObject.groupID
        let shareURL = URL(string: "drinkWhat://share?groupID=\(groupID)")!
        let aVC = UIActivityViewController(activityItems: [shareURL], applicationActivities: nil)
        present(aVC, animated: true)
    }

    @objc private func cancelButtonTapped() {
        delegate?.didPressCancelButton(self)
    }
    private func setupTableView() {
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
    }
    private func setupEndVoteButton() {
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

    private func setupCancelLabel() {
        view.addSubview(cancelLabel)
        NSLayoutConstraint.activate([
            cancelLabel.topAnchor.constraint(equalTo: tableView.bottomAnchor, constant: 20),
            cancelLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            cancelLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            cancelLabel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20)
        ])
    }

}
extension VotingViewController {
    private func makeTableView() -> UITableView {
        let tableView = UITableView(frame: .zero)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.register(VotingCell.self, forCellReuseIdentifier: "VotingCell")
        tableView.contentInsetAdjustmentBehavior = .never
//        tableView.separatorStyle = .none
        tableView.allowsSelection = false
        return tableView
    }
    private func makeEndVoteButton() -> UIButton {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        let normalBackground = UIColor.darkLogoBrown.toImage()
        let selectedBackground = UIColor.darkLogoBrown.withAlphaComponent(0.8).toImage()
        button.setBackgroundImage(normalBackground, for: .normal)
        button.setBackgroundImage(selectedBackground, for: .highlighted)
        button.titleLabel?.font = .medium2()
        button.setTitleColor(UIColor.white, for: .normal)
        button.setTitle("結束投票", for: .normal)
        button.addTarget(self, action: #selector(endVoteButtonTapped), for: .touchUpInside)
        return button
    }
    @objc func endVoteButtonTapped() {
        delegate?.didPressEndVoteButton(self)
    }
    private func makeLabel() -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.font = .medium2()
        label.textColor = UIColor.darkGray
        label.textAlignment = .center
        label.alpha = 0.9
        label.text = "此投票已取消"
        return label
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
