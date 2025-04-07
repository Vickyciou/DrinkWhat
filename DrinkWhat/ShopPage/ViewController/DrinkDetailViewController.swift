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
    private let footerView = DrinkDetailTableViewFooter(frame: CGRect(x: 0, y: 0, width: 100, height: 100))

    private let viewModel: DrinkDetailViewModel

    init(shopObject: ShopObject, drink: ShopMenu, dataSource: DrinkDetailDataSourceProtocol) {
        self.viewModel = DrinkDetailViewModel(drink: drink, shopObject: shopObject, dataSource: dataSource)
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupVC()
        viewModel.delegate = self
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
        topView.setupTopView(drinkName: viewModel.getDrink().drinkName, price: viewModel.calculateDrinkPrice())
    }
    private func setupTableView() {
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: topView.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
        tableView.tableFooterView = footerView
        footerView.delegate = self
    }
    private func setupAddItemButtonButton() {
        view.addSubview(addItemButton)
        NSLayoutConstraint.activate([
            addItemButton.topAnchor.constraint(equalTo: tableView.bottomAnchor, constant: 20),
            addItemButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            addItemButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            addItemButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            addItemButton.heightAnchor.constraint(equalToConstant: 44)
        ])
        addItemButton.layer.cornerRadius = 10
        addItemButton.clipsToBounds = true
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
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(UIColor.lightGrayBrown, for: .normal)
        let normalBackground = UIColor.darkLogoBrown.toImage()
        let selectedBackground = UIColor.darkLogoBrown.withAlphaComponent(0.8).toImage()
        button.setBackgroundImage(normalBackground, for: .normal)
        button.setBackgroundImage(selectedBackground, for: .highlighted)
        button.titleLabel?.font = .medium2()
        button.setTitle("加入品項", for: .normal)
        button.addTarget(self, action: #selector(addItemButtonTapped), for: .touchUpInside)
        return button
    }
    @objc func addItemButtonTapped() {
        view.endEditing(true)
        Task {
            do {
                try await viewModel.addOrderObject()

                makeAlertToast(message: "\(viewModel.getDrink().drinkName)", title: "已成功加入", duration: 2)
                dismiss(animated: true)
            } catch OrderManagerError.selectionMissingError {
                let alert = UIAlertController(
                    title: "加入失敗",
                    message: "容量、甜度、冰量都需要選取哦！",
                    preferredStyle: .alert
                )
                let okAction = UIAlertAction(title: "OK", style: .default)
                alert.addAction(okAction)
                present(alert, animated: true)

            } catch UserManagerError.noCurrentUser {
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

            } catch OrderManagerError.noData {
                let alert = UIAlertController(
                    title: "加入失敗",
                    message: "尚未加入任何團購群組哦！",
                    preferredStyle: .alert
                )
                let okAction = UIAlertAction(title: "OK", style: .default)
                alert.addAction(okAction)
                present(alert, animated: true)

            } catch OrderManagerError.noMatchData {
                let alert = UIAlertController(
                    title: "加入失敗",
                    message: "查無此商店進行中的團購哦！",
                    preferredStyle: .alert
                )
                let okAction = UIAlertAction(title: "OK", style: .default)
                alert.addAction(okAction)
                present(alert, animated: true)
            } catch {
                print("Fail with add OrderObject \(error)")
            }
        }
    }
}
extension DrinkDetailViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        4
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.numberOfRowsInSection(section: section)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "DrinkDetailCell", for: indexPath)
                as? DrinkDetailCell else { fatalError("Cannot created DrinkDetailCell") }

        let section = indexPath.section
        switch section {
        case 0:
            cell.setupCell(
                description: viewModel.getDrink().drinkPrice[indexPath.row].volume,
                isSelected: viewModel.currentVolumeIndexSelected(index: indexPath.row)
            )
            return cell
        case 1:
            cell.setupCell(
                description: viewModel.getDataSource().sugar[indexPath.row],
                isSelected: viewModel.currentSugarIndexSelected(index: indexPath.row)
            )
            return cell
        case 2:
            cell.setupCell(
                description: viewModel.getDataSource().ice[indexPath.row],
                isSelected: viewModel.currentIceIndexSelected(index: indexPath.row)
            )
            return cell
        case 3:
            let addToppings = viewModel.getShopObject().addToppings[indexPath.row]
            cell.setupAddToppingCell(
                description: addToppings.topping,
                addPrice: addToppings.price,
                isSelected: viewModel.currentAddToppingsIndexesSelected(index: indexPath.row)
            )
            return cell
        default:
            return cell
        }
    }
}

extension DrinkDetailViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 32
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = .lightGrayBrown
        let titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = .medium3()
        titleLabel.textColor = .darkLogoBrown
        headerView.addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: headerView.topAnchor, constant: 4),
            titleLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -8),
            titleLabel.bottomAnchor.constraint(equalTo: headerView.bottomAnchor, constant: -4)])

        switch section {
        case 0:
            titleLabel.text = "容量"
        case 1:
            titleLabel.text = "甜度"
        case 2:
            titleLabel.text = "冰量"
        case 3:
            if !viewModel.getShopObject().addToppings.isEmpty {
                titleLabel.text = "加料"
            } else {
                titleLabel.text = nil
            }
        default:
            titleLabel.text = nil
        }

        return headerView
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
            viewModel.setCurrentVolumeIndex(index: indexPath.row)
        case 1:
            viewModel.setCurrentSugarIndex(index: indexPath.row)
        case 2:
            viewModel.setCurrentIceIndex(index: indexPath.row)
        case 3:
            viewModel.setCurrentAddToppingIndexes(index: indexPath.row)
        default:
            return
        }
        tableView.reloadData()
    }
}

extension DrinkDetailViewController: DrinkDetailTableViewFooterDelegate {
    func textFieldEndEditing(_ view: DrinkDetailTableViewFooter, text: String) {
        viewModel.setNote(note: text)
    }
}

extension DrinkDetailViewController: DrinkDetailViewModelDelegate {
    func topViewNeedToReloadData(_ viewModel: DrinkDetailViewModel) {
        topView.setupTopView(
            drinkName: viewModel.getDrink().drinkName,
            price: viewModel.calculateDrinkPrice()
        )
    }
}
