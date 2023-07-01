//
//  OrderingViewController.swift
//  DrinkWhat
//
//  Created by Vickyciou on 2023/6/30.
//

import UIKit

class OrderingViewController: UIViewController {
    private lazy var tableView: UITableView = makeTableView()
    private let orderManager = OrderManager()
    private let orderResponse: OrderResponse
    private var orderResults: [OrderResults] = []
    private var userObject: UserObject? {
        UserManager.shared.userObject
    }
    private var joinUserObjects: [UserObject] = []
    private var isInitiator: Bool

    init(orderResponse: OrderResponse, isInitiator: Bool) {
        self.orderResponse = orderResponse
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
        setNavController()
        setupTableView()
        orderManager.delegate = self
//        orderManager.listenOrderResults(orderID: orderResponse.orderID)
    }

    private func setNavController() {
        navigationItem.title = "\(orderResponse.initiatorUserName)的團購訂單"
        navigationItem.title = "訂購店家：\(orderResponse.shopName)"
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

extension OrderingViewController {
    private func makeTableView() -> UITableView {
        let tableView = UITableView(frame: .zero)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
//        tableView.delegate = self
        tableView.register(CustomDrinkCell.self, forCellReuseIdentifier: "CustomDrinkCell")
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.separatorStyle = .none
        return tableView
    }
}

extension OrderingViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        orderResults.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell =
                tableView.dequeueReusableCell(withIdentifier: "CustomDrinkCell", for: indexPath) as? CustomDrinkCell
        else { fatalError("Cannot created CustomDrinkCell") }

        let orderObject = orderResults[indexPath.row].orderObjects[indexPath.row]
        let addToppings = orderObject.addToppings[indexPath.row]

        cell.setupCell(drinkName: orderObject.drinkName,
                       volume: orderObject.volume,
                       ice: orderObject.ice,
                       sugar: orderObject.sugar,
                       addToppings: "\(addToppings.topping)" + "+\(addToppings.price)",
                       note: orderObject.note,
                       price: orderObject.drinkPrice)

        return cell
    }
}
extension OrderingViewController: OrderManagerDelegate {
    func orderManager(_ manager: OrderManager, didGetAllOrderData orderData: [OrderResponse]) {
        return
    }

    func orderManager(_ manager: OrderManager, didGetOrderResults orderResults: [OrderResults]) {
        self.orderResults = orderResults
    }

    func orderManager(_ manager: OrderManager, didFailWith error: Error) {
        print(error.localizedDescription)
    }

}

extension OrderingViewController: UserObjectsAccessible {
    func setUserObjects(_ userObjects: [UserObject]) {
        joinUserObjects = userObjects
    }
}

extension OrderingViewController: OrderResultsAccessible {
    func setOrderResults(_ orderResults: [OrderResults]) {
        self.orderResults = orderResults
    }


}
