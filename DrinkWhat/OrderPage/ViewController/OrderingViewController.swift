//
//  OrderingViewController.swift
//  DrinkWhat
//
//  Created by Vickyciou on 2023/6/30.
//

import UIKit

protocol OrderingViewControllerDelegate: AnyObject {
    func didPressAddItemButton(_ vc: OrderingViewController, orderResponse: OrderResponse)
}

class OrderingViewController: UIViewController {

    enum BottomViewUIState {
//        case isInitiator
//        case isFinished
        case initialUser
        case initialUserFinished
        case joinUser
        case joinUserFinished
    }

    private lazy var tableView: UITableView = makeTableView()
    private let orderManager = OrderManager()
    private var orderResponse: OrderResponse
    private var orderResults: [OrderResults] = []
    private var userObject: UserObject? {
        UserManager.shared.userObject
    }
    private var joinUserObjects: [UserObject] = []
    private var isInitiator: Bool
    private var isFinished: Bool {
        orderResponse.state == OrderStatus.canceled.rawValue
            || orderResponse.state == OrderStatus.finished.rawValue
        ? true : false
    }
    weak var delegate: OrderingViewControllerDelegate?
    private let footerView = OrderTableViewFooter(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
    private let headerView = OrderTableViewHeader(frame: CGRect(x: 0, y: 0, width: 100, height: 50))
    private var state: BottomViewUIState {
        if isInitiator && isFinished {
            return BottomViewUIState.initialUserFinished
        } else if isInitiator && isFinished == false {
            return BottomViewUIState.initialUser
        } else if isInitiator == false && isFinished {
            return BottomViewUIState.joinUserFinished
        } else {
            return BottomViewUIState.joinUser
        }
    }

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
        view.backgroundColor = .white
        setNavController()
        setupTableView()
        setupStateUI()
        setupBottomView(state: state)
    }

    private func setNavController() {
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = UIColor.white
        appearance.titleTextAttributes = [.foregroundColor: UIColor.darkLogoBrown]
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.darkLogoBrown]
        appearance.shadowColor = UIColor.clear
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationItem.title = "\(orderResponse.initiatorUserName)的團購訂單"
        tabBarController?.tabBar.backgroundColor = .white

        let closeImage = UIImage(systemName: "xmark")?
            .withConfiguration(UIImage.SymbolConfiguration(pointSize: 16))
            .setColor(color: .darkLogoBrown)
        let shareImage = UIImage(systemName: "square.and.arrow.up")?
            .withConfiguration(UIImage.SymbolConfiguration(pointSize: 16))
            .setColor(color: .darkLogoBrown)

        let closeButton = UIBarButtonItem(image: closeImage,
                                          style: .plain,
                                          target: self,
                                          action: #selector(closeButtonTapped))
        let shareButton = UIBarButtonItem(image: shareImage,
                                          style: .plain,
                                          target: self,
                                          action: #selector(shareButtonTapped))


        navigationItem.setRightBarButtonItems([closeButton, shareButton], animated: false)

//        if !isInitiator ||
//            orderResponse.state == OrderStatus.canceled.rawValue ||
//            orderResponse.state == OrderStatus.finished.rawValue {
//            navigationItem.leftBarButtonItem = nil
//        } else {
//            navigationItem.setLeftBarButton(cancelButton, animated: false)
//        }
    }
    @objc private func closeButtonTapped() {
        dismiss(animated: true)
    }
    @objc private func shareButtonTapped() {
        let orderID = orderResponse.orderID
        let shareURL = URL(string: "drinkWhat://share?orderID=\(orderID)")!
        let aVC = UIActivityViewController(activityItems: [shareURL], applicationActivities: nil)
        present(aVC, animated: true)
    }
    @objc func cancelButtonTapped() {
        let alert = UIAlertController(
            title: "取消團購",
            message: "確定要取消此團購群組嗎？",
            preferredStyle: .alert
        )
        let confirmAction = UIAlertAction(title: "確定", style: .default) { [self]_ in
            orderManager.setOrderStatus(orderID: orderResponse.orderID,
                                       status: OrderStatus.canceled.rawValue)
            self.dismiss(animated: true)
        }
        let cancelAction = UIAlertAction(title: "先不要", style: .cancel)
        alert.addAction(confirmAction)
        alert.addAction(cancelAction)

        present(alert, animated: true)
    }

    private func setupTableView() {
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
        footerView.delegate = self
        tableView.tableHeaderView = headerView
        tableView.tableFooterView = footerView
    }

    private func setupStateUI() {
        switch state {
        case .initialUser:
            let trashImage = UIImage(systemName: "trash")?
                .setColor(color: .darkLogoBrown)
                .withConfiguration(UIImage.SymbolConfiguration(pointSize: 16))
            let cancelButton = UIBarButtonItem(image: trashImage,
                                               style: .plain,
                                               target: self,
                                               action: #selector(cancelButtonTapped))
            navigationItem.setLeftBarButton(cancelButton, animated: false)
        case .joinUser, .initialUserFinished, .joinUserFinished:
            navigationItem.leftBarButtonItem = nil
        }
    }

    private func setupBottomView(state: BottomViewUIState) {
        var bottomView: UIView = {
            switch state {
            case .initialUser:
                let view = InitiatorOrderingBottomView(frame: .zero)
                let trashImage = UIImage(systemName: "trash")?
                    .setColor(color: .darkLogoBrown)
                    .withConfiguration(UIImage.SymbolConfiguration(pointSize: 16))
                let cancelButton = UIBarButtonItem(image: trashImage,
                                                   style: .plain,
                                                  target: self,
                                                  action: #selector(cancelButtonTapped))
                navigationItem.setLeftBarButton(cancelButton, animated: false)
                view.delegate = self
                return view
            case .joinUser:
                let view = JoinUsersBottomView(frame: .zero)
                view.updateView(isFinished: false)
                view.delegate = self
                navigationItem.leftBarButtonItem = nil
                return view
            case .initialUserFinished:
                let view = OrderFinishedBottomView(frame: .zero)
                navigationItem.leftBarButtonItem = nil
                return view
            case .joinUserFinished:
                let view = JoinUsersBottomView(frame: .zero)
                view.updateView(isFinished: true)
                view.delegate = self
                navigationItem.leftBarButtonItem = nil
                return view
            }

        }()
        view.addSubview(bottomView)
        bottomView.translatesAutoresizingMaskIntoConstraints = false
        bottomView.backgroundColor = .white
        NSLayoutConstraint.activate([
            bottomView.topAnchor.constraint(equalTo: tableView.bottomAnchor),
            bottomView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            bottomView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            bottomView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -4)
        ])
    }
}
extension OrderingViewController {
    private func makeTableView() -> UITableView {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(CustomDrinkCell.self, forCellReuseIdentifier: "CustomDrinkCell")
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.separatorStyle = .none
        tableView.backgroundColor = .white
        return tableView
    }
    
}

extension OrderingViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        orderResults[section].orderObjects.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell =
                tableView.dequeueReusableCell(withIdentifier: "CustomDrinkCell", for: indexPath) as? CustomDrinkCell
        else { fatalError("Cannot created CustomDrinkCell") }
        let orderResult = orderResults[indexPath.section]
        let orderObject = orderResult.orderObjects[indexPath.row]
        let toppings = orderObject.addToppings.compactMap { "\($0.topping)" + "+ $\($0.price)" }
        cell.setupCell(drinkName: orderObject.drinkName,
                       volume: orderObject.volume,
                       ice: orderObject.ice,
                       sugar: orderObject.sugar,
                       addToppings: toppings,
                       note: orderObject.note,
                       price: orderObject.drinkPrice)

        return cell
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        orderResults.count
    }
}
extension OrderingViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = OrderSectionHeaderView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.width, height: 60))
        headerView.delegate = self
        let order = orderResults[section]
        if let user = joinUserObjects.first(where: { $0.userID == order.userID }) {
            headerView.setupView(userImageURL: user.userImageURL,
                                 userName: user.userName ?? "",
                                 isPaid: order.isPaid,
                                 indexOfSection: section)
        }
        return headerView
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footView = OrderSectionFooterView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.width, height: 30))
        let order = orderResults[section].orderObjects
        let totalPrice = order.reduce(into: 0) { $0 += $1.drinkPrice }
        footView.setupView(price: totalPrice)
        return footView
    }

    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        orderResponse.state == OrderStatus.active.rawValue ? true : false
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let section = indexPath.section
        let order = orderResults[section]
        let orderObject = order.orderObjects[indexPath.row]

        if editingStyle == .delete {
            orderManager.removeOrderObject(userID: order.userID,
                                           orderID: orderResponse.orderID,
                                           orderObject: orderObject)
        }
        orderResults[section].orderObjects.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .fade)
    }
}
extension OrderingViewController: InitiatorOrderingBottomViewDelegate {
    func addItemButtonTapped(_ view: InitiatorOrderingBottomView) {
        let shopMenuVC = ShopMenuViewController(shopObject: orderResponse.shopObject)
        present(shopMenuVC, animated: true)
    }

    func finishButtonTapped(_ view: InitiatorOrderingBottomView) {
        orderManager.setOrderStatus(orderID: orderResponse.orderID,
                                   status: OrderStatus.finished.rawValue)
    }
}
extension OrderingViewController: JoinUsersBottomViewDelegate {
    func linePayButtonTapped(_ view: JoinUsersBottomView) {
        guard let linePayURL = URL(string: "https://line.me/R/nv/wallet"),
              let lineURL = URL(string: "https://line.me/R/") else { return }

        if UIApplication.shared.canOpenURL(linePayURL) {
            UIApplication.shared.open(linePayURL, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.open(lineURL, options: [:], completionHandler: nil)
        }
    }

    func addItemButtonTapped(_ view: JoinUsersBottomView) {
        dismiss(animated: true) { [self] in
            delegate?.didPressAddItemButton(self, orderResponse: orderResponse)
        }
    }
}
extension OrderingViewController: OrderSectionHeaderViewDelegate {
    func didPressedPaidStatusButton(_ view: OrderSectionHeaderView, indexOfSection: Int) {
        let alert = UIAlertController(
            title: "付款確認",
            message: "是否已完成付款？",
            preferredStyle: .alert
        )
        let confirmAction = UIAlertAction(title: "是的", style: .default) { [self]_ in
            let user = orderResults[indexOfSection].userID
            orderManager.updatePaidStatusToTrue(orderID: orderResponse.orderID,
                                          userID: user)
        }
        let cancelAction = UIAlertAction(title: "還沒", style: .cancel) { [self]_ in
            let user = orderResults[indexOfSection].userID
            orderManager.updatePaidStatusToFalse(orderID: orderResponse.orderID,
                                          userID: user)
        }
        alert.addAction(confirmAction)
        alert.addAction(cancelAction)
        present(alert, animated: true)
    }
}

extension OrderingViewController: OrderTableViewFooterDelegate {
    func exitButtonTapped(_ view: OrderTableViewFooter) {
        let alert = UIAlertController(
            title: "離開此團購",
            message: "確定要離開嗎？",
            preferredStyle: .alert
        )
        let leaveAction = UIAlertAction(title: "離開", style: .default) { [self] _ in
            if let userObject {
                orderManager.removeUserFromOrder(userID: userObject.userID, orderID: orderResponse.orderID)
            }
            dismiss(animated: true)
        }
        let cancelAction = UIAlertAction(title: "先不要", style: .cancel)
        alert.addAction(leaveAction)
        alert.addAction(cancelAction)
        present(alert, animated: true)

    }
}

extension OrderingViewController: UserObjectsAccessible {
    func setUserObjects(_ userObjects: [UserObject]) {
        joinUserObjects = userObjects
        tableView.reloadData()
        DispatchQueue.main.async { [self] in
            headerView.setupView(shopName: orderResponse.shopObject.name)
        }
    }
}

extension OrderingViewController: OrderResultsAccessible {
    func setOrderResults(_ orderResults: [OrderResults]) {
        self.orderResults = orderResults
        tableView.reloadData()

        let orderObject = orderResults.map { $0.orderObjects }
        let amount = orderObject.flatMap { $0 }.reduce(0, { $0 + $1.drinkPrice })
        let isJoinUserAndOrderActive = isInitiator == false && isFinished == false
        footerView.setupView(amount: amount, exitButtonIsHidden: !isJoinUserAndOrderActive)
    }
}
extension OrderingViewController: OrderResponseAccessible {
    func setOrderResponse(_ orderResponse: OrderResponse) {
        self.orderResponse = orderResponse
        DispatchQueue.main.async { [self] in
            setupBottomView(state: state)
        }
    }
}
