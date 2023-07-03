//
//  OrderViewController.swift
//  DrinkWhat
//
//  Created by Vickyciou on 2023/6/15.
//

import UIKit

class OrderViewController: UIViewController {
    private lazy var tableView: UITableView = makeTableView()
    private let orderManager = OrderManager()
    private var userObject: UserObject? {
        UserManager.shared.userObject
    }
    private var orderResponses: [OrderResponse] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        setupVC()
    }

    private func setupVC() {
        setNavController()
        setupTableView()
        orderManager.delegate = self

        guard let userObject else { return }
        orderManager.listenOrderResponse(userID: userObject.userID)

        let orderingVC = OrderingViewController()
        orderingVC.delegate = self

    }

    private func setNavController() {
        navigationItem.title = "團購首頁"
        tabBarController?.tabBar.backgroundColor = .white
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

extension OrderViewController {
    private func makeTableView() -> UITableView {
        let tableView = UITableView(frame: .zero)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(MainOrderCell.self, forCellReuseIdentifier: "MainOrderCell")
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.separatorStyle = .none
        return tableView
    }
}

extension OrderViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            let continueOrders = orderResponses.filter({ $0.state == "進行中" })
            return continueOrders.count
        case 1:
            let finishedOrders = orderResponses.filter({ $0.state == "已完成" || $0.state == "已取消"})
            return finishedOrders.count
        default:
            return 0
        }

    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MainOrderCell", for: indexPath) as? MainOrderCell,
              let userName = userObject?.userName else { fatalError("Cannot created MainOrderCell") }

        switch indexPath.section {
        case 0:
            let continueOrders = orderResponses.filter({ $0.state == "進行中" })
            let continueOrder = continueOrders[indexPath.row]
            let date = Date(timeIntervalSince1970: continueOrder.date)
            let dateString = date.dateToString(date: date)
            cell.setupCell(shopImageURL: continueOrder.shopLogoImageURL,
                           shopName: continueOrder.shopName,
                           description: "由\(continueOrder.initiatorUserName)發起的團購",
                           date: dateString)
            return cell
        case 1:
            let finishedOrders = orderResponses.filter({ $0.state == "已完成" || $0.state == "已取消"})
            let finishedOrder = finishedOrders[indexPath.row]
            let date = Date(timeIntervalSince1970: finishedOrder.date)
            let dateString = date.dateToString(date: date)
            cell.setupCell(shopImageURL: finishedOrder.shopLogoImageURL,
                           shopName: finishedOrder.shopName,
                           description: "由\(userName)發起的團購",
                           date: dateString)
            return cell
        default:
            return cell
        }
    }
}

extension OrderViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            let continueOrders = orderResponses.filter({ $0.state == "進行中" })
            let orderVC = OrderNavigationController(orderResponse: continueOrders[indexPath.row])
            present(orderVC, animated: true)
        case 1:
            let finishedOrders = orderResponses.filter({ $0.state == "已完成" || $0.state == "已取消"})
            let orderVC = OrderNavigationController(orderResponse: finishedOrders[indexPath.row])
            present(orderVC, animated: true)
        default:
            return
        }
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "進行中的團購"
        case 1:
            return "已完成的團購"
        default:
            return ""
        }
    }
}
extension OrderViewController: OrderManagerDelegate {
    func orderManager(_ manager: OrderManager, didGetAllOrderData orderData: [OrderResponse]) {
        let sortedOrderData = orderData.sorted(by: { $0.date > $1.date })
        self.orderResponses = sortedOrderData
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }

    func orderManager(_ manager: OrderManager, didGetOrderResults orderResults: [OrderResults]) {
        return
    }

    func orderManager(_ manager: OrderManager, didFailWith error: Error) {
        print(error.localizedDescription)
    }
}

extension OrderViewController: OrderingViewControllerDelegate {
    func didPressAddItemButton(_ vc: OrderingViewController) {
        <#code#>
    }

}
