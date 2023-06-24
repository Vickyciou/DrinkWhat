//
//  ShopMenuViewController.swift
//  DrinkWhat
//
//  Created by Vickyciou on 2023/6/22.
//

import UIKit

class ShopMenuViewController: UIViewController {
    private lazy var tableHeaderView: UIImageView = makeTableHeaderView()
    private lazy var tableView: UITableView = makeTableView()
    private let shopID: String
    private let shopManager = ShopManager()
    private let groupManager = GroupManager()
    private var shopObject: ShopObject?
    private var groupObject: GroupResponse?

    init(shopID: String) {
        self.shopID = shopID
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupVC()
        shopManager.delegate = self
        groupManager.delegate = self
    }

    private func setupVC() {
        setupTableView()
        shopManager.getShopObject(shopID: shopID)
    }

    private func setupTableView() {
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        tableView.tableHeaderView = tableHeaderView
    }
}

extension ShopMenuViewController {
    private func makeTableHeaderView() -> UIImageView {
        let tableHeaderView = UIImageView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 200))
        tableHeaderView.contentMode = .scaleAspectFill
        tableHeaderView.layer.masksToBounds = true
        return tableHeaderView
    }

    private func makeTableView() -> UITableView {
        let tableView = UITableView(frame: .zero)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(ShopMenuCell.self, forCellReuseIdentifier: "ShopMenuCell")
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.separatorStyle = .none
        tableView.sectionHeaderHeight = UITableView.automaticDimension
        tableView.sectionHeaderTopPadding = 0.0
        return tableView
    }
}

extension ShopMenuViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return shopObject?.menu.count ?? 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ShopMenuCell", for: indexPath) as? ShopMenuCell,
              let shopObject = shopObject else { fatalError("Cannot created ShopMenuCell") }
        let drink = shopObject.menu[indexPath.row]
        cell.setupCell(drinkName: drink.drinkName, drinkPrice: drink.drinkPrice[0].price)
        return cell
    }
}

// 這邊要寫section header
extension ShopMenuViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {}

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let firstSectionHeaderView = SectionHeaderView(frame: .zero)
        firstSectionHeaderView.setupView(shopName: shopObject?.name ?? "")
        firstSectionHeaderView.delegate = self
        return section == 0 ? firstSectionHeaderView : nil
    }
}

extension ShopMenuViewController: ShopManagerDelegate {
    func shopManager(_ manager: ShopManager, didGetShopObject shopObject: ShopObject) {
        self.shopObject = shopObject
        tableHeaderView.loadImage(shopObject.mainImageURL, placeHolder: UIImage(systemName: "bag"))
        tableView.reloadData()
    }
}

extension ShopMenuViewController: SectionHeaderViewDelegate {
    func didPressAddOrderButton(_ view: SectionHeaderView) {
        //
    }

    func didPressAddVoteButton(_ view: SectionHeaderView) {
        Task {
            do {
                try await groupManager.addShopIntoGroup(shopID: shopID)
            } catch ManagerError.itemAlreadyExistsError {
                let alert = UIAlertController(
                    title: "加入失敗",
                    message: "此商店已加入投票清單囉",
                    preferredStyle: .alert
                )
                let okAction = UIAlertAction(title: "OK", style: .default)
                alert.addAction(okAction)
                present(alert, animated: true)
            } catch {
                print("error \(error)")
            }
        }
    }

    func didPressAddFavoriteButton(_ view: SectionHeaderView) {
        //
    }
}
extension ShopMenuViewController: GroupManagerDelegate {
    func groupManager(_ manager: GroupManager, didPostGroupID groupID: String) {
        print("groupID \(groupID)")
    }
    func groupManager(_ manager: GroupManager, didGetGroupObject groupObject: GroupResponse) {
        self.groupObject = groupObject
    }
    func groupManager(_ manager: GroupManager, didFailWith error: Error) {
        print(error)
    }
}
