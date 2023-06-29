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
    private var shopObject: ShopObject
    private var drink: ShopMenu
    private var currentVolumeIndex: Int = 0
    private var currentSugarIndex: Int = 0
    private var currentIceIndex: Int = 0
    private var currentAddToppingsIndex: Int?
    private var drinkPrice: Int {
        if currentAddToppingsIndex != nil {
            return drink.drinkPrice[currentVolumeIndex].price + shopObject.addToppings[currentAddToppingsIndex!].price
        } else {
            return drink.drinkPrice[currentVolumeIndex].price
        }
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
//        tableView.contentInsetAdjustmentBehavior = .never
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
        let selectedIndexPaths = tableView.indexPathsForSelectedRows ?? []
        var hasSelection = false

        for section in 0..<4 {
            let sectionIndexPaths = selectedIndexPaths.filter { $0.section == section }
            if !sectionIndexPaths.isEmpty {
                hasSelection = true
                break
            }
        }

        if hasSelection {
            // 在這裡將選取的儲存格項目加入 Firestore
            // 您可以使用 selectedIndexPaths 來取得選取的儲存格的 IndexPath
        } else {
            // 如果沒有選取儲存格，執行相應的處理
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
            cell.setupCell(description: drink.drinkPrice[indexPath.row].volume)
            return cell
        case 1:
            cell.setupCell(description: dataSource.sugar[indexPath.row])
            return cell
        case 2:
            cell.setupCell(description: dataSource.ice[indexPath.row])
            return cell
        case 3:
            let addToppings = shopObject.addToppings[indexPath.row]
            cell.setupAddToppingCell(description: addToppings.topping, addPrice: addToppings.price)
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
        if let selectIndexPathInSection = tableView.indexPathsForSelectedRows?.first(where: {
            $0.section == indexPath.section
        }) {
            tableView.deselectRow(at: selectIndexPathInSection, animated: false)
            guard let cell = tableView.cellForRow(at: selectIndexPathInSection) as? DrinkDetailCell
                  else { fatalError("Cannot created DrinkDetailCell") }
            cell.chooseButton.isSelected = false
        }
        return indexPath
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? DrinkDetailCell
              else { fatalError("Cannot created DrinkDetailCell") }
        cell.chooseButton.isSelected = true
        let section = indexPath.section
        switch section {
        case 0:
            currentVolumeIndex = indexPath.row
            topView.setupTopView(drinkName: drink.drinkName, price: drinkPrice)
        case 1:
            currentSugarIndex = indexPath.row
        case 2:
            currentIceIndex = indexPath.row
        case 3:
            currentAddToppingsIndex = indexPath.row
            topView.setupTopView(drinkName: drink.drinkName, price: drinkPrice)
        default:
            return
        }
    }
}
