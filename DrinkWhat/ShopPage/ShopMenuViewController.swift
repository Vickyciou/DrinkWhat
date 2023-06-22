//
//  ShopMenuViewController.swift
//  DrinkWhat
//
//  Created by Vickyciou on 2023/6/22.
//

import UIKit

class ShopMenuViewController: UIViewController {
    private lazy var tableView: UITableView = makeTableView()
    let shopID: String
    private let shopManager = ShopManager()
    private var shopObject: ShopObject?

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
    }
}

extension ShopMenuViewController {
    private func makeTableView() -> UITableView {
        let tableView = UITableView(frame: .zero)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(ShopMenuCell.self, forCellReuseIdentifier: "ShopMenuCell")
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.separatorStyle = .none
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
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//      let shopMenuVC = ShopMenuViewController(shopID: shopData[indexPath.row].id)
//        present(shopMenuVC, animated: true)
    }
}

extension ShopMenuViewController: ShopManagerDelegate {
    func shopManager(_ manager: ShopManager, didGetShopObject shopObject: ShopObject) {
        self.shopObject = shopObject
        tableView.reloadData()
    }
}
