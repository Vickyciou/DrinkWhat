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
        case isInitialUser
        case isJoinUser
        case isFinished
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
    weak var delegate: OrderingViewControllerDelegate?
    private var state: BottomViewUIState {
        if orderResponse.state == OrderStatus.canceled.rawValue
            || orderResponse.state == OrderStatus.finished.rawValue {
            return .isFinished
        } else if isInitiator {
            return .isInitialUser
        } else {
            return .isJoinUser
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
        setupBottomView(state: state)
    }

    private func setNavController() {
        navigationItem.title = "\(orderResponse.initiatorUserName)的團購訂單"
        tabBarController?.tabBar.backgroundColor = .white

        let closeImage = UIImage(systemName: "xmark")?
            .withConfiguration(UIImage.SymbolConfiguration(pointSize: 18))
            .setColor(color: .darkBrown)
        let shareImage = UIImage(systemName: "square.and.arrow.up")?
            .withConfiguration(UIImage.SymbolConfiguration(pointSize: 18))
            .setColor(color: .darkBrown)
        let closeButton = UIBarButtonItem(image: closeImage,
                                          style: .plain,
                                          target: self,
                                          action: #selector(closeButtonTapped))
        let shareButton = UIBarButtonItem(image: shareImage,
                                          style: .plain,
                                          target: self,
                                          action: #selector(shareButtonTapped))
        navigationItem.setRightBarButtonItems([closeButton, shareButton], animated: false)
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

    private func setupTableView() {
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
        let headerView = OrderTableViewHeader(frame: CGRect(x: 0, y: 0, width: 100, height: 50))
        headerView.setupView(shopName: orderResponse.shopObject.name)
        tableView.tableHeaderView = headerView

        let footerView = OrderTableViewFooter(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        let orderObject = orderResults.map { $0.orderObjects }
        let amount = orderObject.flatMap { $0 }.reduce(0, { $0 + $1.drinkPrice })
        footerView.setupView(amount: amount, isInitiator: isInitiator)
        footerView.delegate = self
        tableView.tableFooterView = footerView
    }
    private func setupBottomView(state: BottomViewUIState) {
        let bottomView: UIView = {
            switch state {
            case .isFinished:
                let view = OrderFinishedBottomView(frame: .zero)
                return view
            case .isInitialUser:
                let view = InitiatorOrderingBottomView(frame: .zero)
                view.delegate = self
                return view
            case .isJoinUser:
                let view = JoinUsersBottomView(frame: .zero)
                view.delegate = self
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
        let order = orderResults[section]
        if let user = joinUserObjects.first(where: { $0.userID == order.userID }) {
            headerView.setupView(userImageURL: user.userImageURL, userName: user.userName ?? "", isPaid: order.isPaid)
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
}
extension OrderingViewController: InitiatorOrderingBottomViewDelegate {
    func cancelButtonTapped(_ view: InitiatorOrderingBottomView) {
        orderManager.setOrderState(orderID: orderResponse.orderID,
                                   status: OrderStatus.canceled.rawValue)
    }

    func finishButtonTapped(_ view: InitiatorOrderingBottomView) {
        orderManager.setOrderState(orderID: orderResponse.orderID,
                                   status: OrderStatus.finished.rawValue)
    }
}
extension OrderingViewController: JoinUsersBottomViewDelegate {
    func linePayButtonTapped(_ view: JoinUsersBottomView) {
        //
    }

    func addItemButtonTapped(_ view: JoinUsersBottomView) {
        delegate?.didPressAddItemButton(self, orderResponse: orderResponse)
        dismiss(animated: true)
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
    }
}

extension OrderingViewController: OrderResultsAccessible {
    func setOrderResults(_ orderResults: [OrderResults]) {
        self.orderResults = orderResults
        tableView.reloadData()
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