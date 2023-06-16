//
//  ShopListToVoteViewController.swift
//  DrinkWhat
//
//  Created by Vickyciou on 2023/6/16.
//

import UIKit

class ShopListToVoteViewController: UIViewController {
    private lazy var tableView: UITableView = makeTableView()
    private lazy var submitButton: UIButton = makeSubmitButton()
    private var selectIndex: Int?

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
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = UIColor.white
        appearance.titleTextAttributes = [.foregroundColor: UIColor.darkBrown ?? .black]
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.darkBrown ?? .black]
        appearance.shadowColor = UIColor.clear
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationItem.title = "Name發起的投票"
        tabBarController?.tabBar.backgroundColor = .white
    }
    private func setupTableView() {
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
//            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
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
}

extension ShopListToVoteViewController {
    private func makeTableView() -> UITableView {
        let tableView = UITableView(frame: .zero)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.register(ShopListToVoteCell.self, forCellReuseIdentifier: "ShopListToVoteCell")
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
        return button
    }
}

extension ShopListToVoteViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        2
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ShopListToVoteCell", for: indexPath)
                as? ShopListToVoteCell else { fatalError("Cannot created VoteCell") }
        cell.setupVoteCell(shopImage: UIImage(systemName: "bag"), shopName: "白巷子")
        cell.delegate = self
        if selectIndex == indexPath.row {
            cell.chooseButton.isSelected = true
        } else {
            cell.chooseButton.isSelected = false
        }
        return cell
    }
}
extension ShopListToVoteViewController: ShopListToVoteCellDelegate {
    func didPressedViewMenuButton(_ cell: ShopListToVoteCell, button: UIButton) {
        print("ViewMenu")
    }
    func didSelectedChooseButton(_ cell: ShopListToVoteCell, button: UIButton) {
        let indexPath = tableView.indexPath(for: cell)
        selectIndex = indexPath?.row
        tableView.reloadData()
    }
}
