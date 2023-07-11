//
//  ShopListToVoteViewController.swift
//  DrinkWhat
//
//  Created by Vickyciou on 2023/6/16.
//

import UIKit

protocol NotVotedViewControllerDelegate: AnyObject {
    func didPressCancelButton(_ vc: NotVotedViewController)
}

class NotVotedViewController: UIViewController {
    private lazy var tableView: UITableView = makeTableView()
    private lazy var submitButton: UIButton = makeSubmitButton()
    private let groupObject: GroupResponse
    private let isInitiator: Bool
    private var shopObjects: [ShopObject] = []
    private var newVoteResults: [(voteResult: VoteResult, isSelected: Bool)] = []
    private let groupManager = GroupManager()
    private let userObject = UserManager.shared.userObject
    private lazy var cancelLabel: UILabel = makeLabel()
    weak var delegate: NotVotedViewControllerDelegate?

    init(groupObject: GroupResponse, isInitiator: Bool) {
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
        if groupObject.state == GroupStatus.canceled.rawValue {
            submitButton.isHidden = true
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
        navigationController?.navigationBar.backgroundColor = .white
        navigationItem.hidesBackButton = true
        let closeImage = UIImage(systemName: "xmark")?
            .withConfiguration(UIImage.SymbolConfiguration(pointSize: 16))
            .setColor(color: .darkLogoBrown)
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
    private func setupSubmitButton() {
        view.addSubview(submitButton)
        NSLayoutConstraint.activate([
            submitButton.topAnchor.constraint(equalTo: tableView.bottomAnchor, constant: 20),
            submitButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            submitButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            submitButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            submitButton.heightAnchor.constraint(equalToConstant: 44)
        ])
        submitButton.layer.cornerRadius = 10
        submitButton.layer.masksToBounds = true
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
extension NotVotedViewController {
    private func makeTableView() -> UITableView {
        let tableView = UITableView(frame: .zero)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(NotVotedCell.self, forCellReuseIdentifier: "NotVotedCell")
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.separatorStyle = .none
        return tableView
    }
    private func makeSubmitButton() -> UIButton {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(UIColor.white, for: .normal)
        let normalBackground = UIColor.darkLogoBrown.toImage()
        let selectedBackground = UIColor.darkLogoBrown.withAlphaComponent(0.8).toImage()
        button.setBackgroundImage(normalBackground, for: .normal)
        button.setBackgroundImage(selectedBackground, for: .highlighted)
        button.titleLabel?.font = .medium2()
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

    private func makeLabel() -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.font = .medium3()
        label.textColor = UIColor.darkGray
        label.textAlignment = .center
        label.alpha = 0.9
        label.text = "此投票已取消"
        return label
    }
}

extension NotVotedViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        newVoteResults.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "NotVotedCell", for: indexPath)
                as? NotVotedCell else { fatalError("Cannot created NotVotedCell") }
        let voteResult = newVoteResults[indexPath.row].voteResult
        let shopID = voteResult.shopID
        guard let shop = shopObjects.first(where: { $0.id == shopID }) else { return cell }
        cell.setupVoteCell(
            number: "\(indexPath.row + 1)",
            shopImageURL: shop.logoImageURL,
            shopName: shop.name,
            numberOfVote: voteResult.userIDs.count
        )
        cell.delegate = self
        cell.chooseButton.isSelected = newVoteResults[indexPath.row].isSelected
        return cell
    }
}

extension NotVotedViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete, let userObject {
            guard groupObject.initiatorUserID == userObject.userID else {
                let alert = UIAlertController(
                    title: "移除店家失敗",
                    message: "只有發起人可以移除店家哦！",
                    preferredStyle: .alert
                )
                let okAction = UIAlertAction(title: "OK", style: .default)
                alert.addAction(okAction)
                present(alert, animated: true)
                return
            }
            groupManager.removeShopFromGroup(groupID: groupObject.groupID,
                                             shopID: shopObjects[indexPath.row].id)
            newVoteResults.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        newVoteResults.indices.forEach { newVoteResults[$0].isSelected = false }
        newVoteResults[indexPath.row].isSelected = true
        tableView.reloadData()
    }
}


extension NotVotedViewController: NotVotedCellDelegate {
    func didPressedViewMenuButton(_ cell: NotVotedCell, button: UIButton) {
        guard let index = tableView.indexPath(for: cell) else { return }
        let shopID = newVoteResults[index.row].voteResult.shopID
        if let shopObject = shopObjects.first { $0.id == shopID } {
            let shopMenuVC = ShopMenuViewController(shopObject: shopObject)
            present(shopMenuVC, animated: true)
        }
    }

//    func didSelectedChooseButton(_ cell: NotVotedCell, button: UIButton) {
//        guard let indexPath = tableView.indexPath(for: cell) else { return }
//        newVoteResults.indices.forEach { newVoteResults[$0].isSelected = false }
//        newVoteResults[indexPath.row].isSelected = true
//        tableView.reloadData()
//    }
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
