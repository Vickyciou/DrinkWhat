//
//  HomeViewController.swift
//  DrinkWhat
//
//  Created by Vickyciou on 2023/6/15.
//

import UIKit

class HomeViewController: UIViewController {
    private lazy var tableView: UITableView = makeTableView()
    private var shopData: [ShopObject] = []
    private let shopManager = ShopManager()

    override func viewDidLoad() {
        super.viewDidLoad()
//        shopManager.set迷客夏Shop()

        setupVC()
        shopManager.delegate = self
    }

    private func setupVC() {
        view.backgroundColor = .white
        setNavController()
        setupTableView()
        shopManager.getAllShopData()
    }
    private func setNavController() {
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = UIColor.white
        appearance.titleTextAttributes = [.foregroundColor: UIColor.darkLogoBrown]
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.darkLogoBrown]
        appearance.shadowColor = UIColor.clear
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationItem.hidesBackButton = true
        navigationItem.title = "飲料店家"
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

extension HomeViewController {
    private func makeTableView() -> UITableView {
        let tableView = UITableView(frame: .zero)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(HomeShopCell.self, forCellReuseIdentifier: "HomeShopCell")
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.separatorStyle = .none
        return tableView
    }
}

extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        shopData.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "HomeShopCell", for: indexPath) as? HomeShopCell
        else { fatalError("Cannot created HomeShopCell") }
        let shop = shopData[indexPath.row]
        cell.setupCell(mainImage: shop.mainImageURL, shopName: shop.name)
        return cell
    }
}

// 這邊要寫section header
extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let shopMenuVC = ShopMenuViewController(shopObject: shopData[indexPath.row])
        present(shopMenuVC, animated: true)
    }
}

extension HomeViewController: ShopManagerDelegate {
    func shopManager(_ manager: ShopManager, didGetShopData shopData: [ShopObject]) {
        self.shopData = shopData
        tableView.reloadData()
    }
    func shopManager(_ manager: ShopManager, didFailWith error: Error) {
        print("Fail got shop data to HomeVC ")
    }
}
