//
//  DrinkDetailViewController.swift
//  DrinkWhat
//
//  Created by Vickyciou on 2023/6/27.
//

import UIKit

class DrinkDetailViewController: UIViewController {

    private let topView = DrinkDetailTopView(frame: .zero)
    private lazy var tableView: UITableView = makeTableView()
    private lazy var addItemButton: UIButton = makeAddItemButton()
    private let dataSource = DrinkDetailDataSource()
    private let orderManager = OrderManager()
    private var shopObject: ShopObject
    private var userObject: UserObject? {
        UserManager.shared.userObject
    }
    private var drink: ShopMenu
    private var currentVolumeIndex: Int?
    private var currentSugarIndex: Int?
    private var currentIceIndex: Int?
    private var currentAddToppingsIndexes: Set<Int> = []
    private var drinkPrice: Int {
        let basePrice = currentVolumeIndex.map { drink.drinkPrice[$0].price } ?? drink.drinkPrice[0].price
        let extraPrice = currentAddToppingsIndexes.map { shopObject.addToppings[$0].price }.reduce(0, +)
        return basePrice + extraPrice
    }

    init(shopObject: ShopObject, drink: ShopMenu) {
        self.shopObject = shopObject
        self.drink = drink
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
        setupTopView()
        setupTableView()
        setupAddItemButtonButton()
    }
    private func setupTopView() {
        view.addSubview(topView)
        topView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            topView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            topView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            topView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
        topView.setupTopView(drinkName: drink.drinkName, price: drinkPrice)
    }
    private func setupTableView() {
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: topView.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
    }
    private func setupAddItemButtonButton() {
        view.addSubview(addItemButton)
        NSLayoutConstraint.activate([
            addItemButton.topAnchor.constraint(equalTo: tableView.bottomAnchor, constant: 20),
            addItemButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            addItemButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            addItemButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20)
        ])
        addItemButton.layer.cornerRadius = 10
        addItemButton.layer.masksToBounds = true
    }

}
extension DrinkDetailViewController {
    private func makeTableView() -> UITableView {
        let tableView = UITableView(frame: .zero)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(DrinkDetailCell.self, forCellReuseIdentifier: "DrinkDetailCell")
        tableView.separatorStyle = .none
        tableView.sectionHeaderHeight = UITableView.automaticDimension
        tableView.sectionHeaderTopPadding = 0.0
        tableView.allowsMultipleSelection = true
        return tableView
    }
    private func makeAddItemButton() -> UIButton {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(UIColor.lightBrown, for: .normal)
        button.setTitleColor(UIColor.midiumBrown, for: .highlighted)
        button.titleLabel?.font = .medium(size: 18)
        button.backgroundColor = UIColor.darkBrown
        button.setTitle("加入品項", for: .normal)
        button.addTarget(self, action: #selector(addItemButtonTapped), for: .touchUpInside)
        return button
    }
    @objc func addItemButtonTapped() {
        Task {
            if let currentVolumeIndex, let currentSugarIndex, let currentIceIndex {
                try await addOrderObject(currentVolumeIndex: currentVolumeIndex,
                                         currentSugarIndex: currentSugarIndex,
                                         currentIceIndex: currentIceIndex)
            } else {
                // 如果沒有選取儲存格，執行相應的處理
                let alert = UIAlertController(
                    title: "加入失敗",
                    message: "容量、甜度、冰量都需要選取哦！",
                    preferredStyle: .alert
                )
                let okAction = UIAlertAction(title: "OK", style: .default)
                alert.addAction(okAction)
                present(alert, animated: true)
            }
        }
    }
    private func addOrderObject(currentVolumeIndex: Int, currentSugarIndex: Int, currentIceIndex: Int) async throws {
        guard let userObject else {
            let alert = UIAlertController(
                title: "加入失敗",
                message: "請先登入會員",
                preferredStyle: .alert
            )
            let loginAction = UIAlertAction(title: "前往登入", style: .default)
            let cancelAction = UIAlertAction(title: "稍後再說", style: .cancel)
            alert.addAction(loginAction)
            alert.addAction(cancelAction)
            present(alert, animated: true)
            return
        }
        var addToppings: [AddTopping] = []
        currentAddToppingsIndexes.forEach { index in
            let topping = shopObject.addToppings[index].topping
            let price = shopObject.addToppings[index].price
            let addTopping = AddTopping(topping: topping, price: price)
            addToppings.append(addTopping)
        }

        let orderObject = OrderObject(
            drinkName: drink.drinkName,
            drinkPrice: drinkPrice,
            volume: drink.drinkPrice[currentVolumeIndex].volume,
            sugar: dataSource.sugar[currentSugarIndex],
            ice: dataSource.ice[currentIceIndex],
            addToppings: addToppings, note: "")
        Task {
                do {
                    try await orderManager.addOrderResult(userID: userObject.userID,
                                                          orderObject: orderObject, shopID: shopObject.id)
                    view.makeAlertToast(message: "\(drink.drinkName)", title: "已成功加入", duration: 2)
                    dismiss(animated: true)
                } catch ManagerError.noData {
                    let alert = UIAlertController(
                        title: "加入失敗",
                        message: "尚未加入任何團購群組哦！",
                        preferredStyle: .alert
                    )
                    let okAction = UIAlertAction(title: "OK", style: .default)
                    alert.addAction(okAction)
                    present(alert, animated: true)
                } catch ManagerError.noMatchData {
                    let alert = UIAlertController(
                        title: "加入失敗",
                        message: "查無此商店進行中的團購哦！",
                        preferredStyle: .alert
                    )
                    let okAction = UIAlertAction(title: "OK", style: .default)
                    alert.addAction(okAction)
                    present(alert, animated: true)
                }
        }
    }
}
extension DrinkDetailViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        4
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return drink.drinkPrice.count
        case 1:
            return dataSource.sugar.count
        case 2:
            return dataSource.ice.count
        case 3:
            return shopObject.addToppings.count
        default:
            return 0
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "DrinkDetailCell", for: indexPath)
                as? DrinkDetailCell else { fatalError("Cannot created DrinkDetailCell") }

        let section = indexPath.section
        switch section {
        case 0:
            cell.setupCell(
                description: drink.drinkPrice[indexPath.row].volume,
                isSelected: currentVolumeIndex == indexPath.row
            )
            return cell
        case 1:
            cell.setupCell(
                description: dataSource.sugar[indexPath.row],
                isSelected: currentSugarIndex == indexPath.row
            )
            return cell
        case 2:
            cell.setupCell(
                description: dataSource.ice[indexPath.row],
                isSelected: currentIceIndex == indexPath.row
            )
            return cell
        case 3:
            let addToppings = shopObject.addToppings[indexPath.row]
            cell.setupAddToppingCell(
                description: addToppings.topping,
                addPrice: addToppings.price,
                isSelected: currentAddToppingsIndexes.contains(indexPath.row)
            )
            return cell
        default:
            return cell
        }
    }
}

extension DrinkDetailViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "容量"
        case 1:
            return "甜度"
        case 2:
            return "冰量"
        case 3:
            if !shopObject.addToppings.isEmpty {
                return "加料"
            } else {
                return nil
            }
        default:
            return ""
        }
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }

    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        if indexPath.section != 3,
           let selectIndexPathInSection = tableView.indexPathsForSelectedRows?.first(where: {
            $0.section == indexPath.section
        }) {
            tableView.deselectRow(at: selectIndexPathInSection, animated: false)
        }
        return indexPath
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let section = indexPath.section
        switch section {
        case 0:
            currentVolumeIndex.toggleValue(indexPath.row)
            currentVolumeIndex = indexPath.row
            topView.setupTopView(drinkName: drink.drinkName, price: drinkPrice)
        case 1:
            currentSugarIndex.toggleValue(indexPath.row)
            currentSugarIndex = indexPath.row
        case 2:
            currentIceIndex.toggleValue(indexPath.row)
            currentIceIndex = indexPath.row
        case 3:
            currentAddToppingsIndexes.toggle(with: indexPath.row)
            topView.setupTopView(drinkName: drink.drinkName, price: drinkPrice)
        default:
            return
        }
        tableView.reloadData()
    }
}

extension Optional where Wrapped == Int {
    mutating func toggleValue(_ value: Int) {
        if let unwrappedValue = self, unwrappedValue == value {
            self = nil
        } else {
            self = value
        }
    }
}

extension Set {
    mutating func toggle(with value: Element) {
        if contains(value) {
            remove(value)
        } else {
            insert(value)
        }
    }
}
