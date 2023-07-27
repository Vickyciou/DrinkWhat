//
//  OrderNavigationController.swift
//  DrinkWhat
//
//  Created by Vickyciou on 2023/7/1.
//

import UIKit

protocol OrderResultsAccessible {
    func setOrderResults(_ orderResults: [OrderResults])
}

protocol OrderResponseAccessible {
    func setOrderResponse(_ orderResponse: OrderResponse)
}

protocol UserObjectsAccessible {
    func setUserObjects(_ userObjects: [UserObject])
}

class OrderNavigationController: UINavigationController {
    private let orderManager = OrderManager()
    private let userObject: UserObject
    private var orderResponse: OrderResponse {
        didSet {
            viewControllers.forEach {
                let orderResponseAccessible = $0 as? OrderResponseAccessible
                orderResponseAccessible?.setOrderResponse(orderResponse)
            }
        }
    }
    private var orderResults: [OrderResults] = [] {
        didSet {
            viewControllers.forEach {
                let orderResultsAccessible = $0 as? OrderResultsAccessible
                orderResultsAccessible?.setOrderResults(orderResults)
            }
        }
    }
    init(orderResponse: OrderResponse, userObject: UserObject) {
        self.orderResponse = orderResponse
        self.userObject = userObject
        let orderingVC = OrderingViewController(
            userObject: userObject,
            orderResponse: orderResponse,
            isInitiator: orderResponse.initiatorUserID == userObject.userID
        )
        orderingVC.setOrderResults(orderResults)
        orderingVC.setOrderResponse(orderResponse)
        super.init(rootViewController: orderingVC)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationItem.hidesBackButton = true
        orderManager.delegate = self
        orderManager.listenOrderResults(orderID: orderResponse.orderID)
        orderManager.listenOrderResponse(userID: userObject.userID)
    }

    private func isInitiator(orderResponse: OrderResponse, userObject: UserObject) -> Bool {
        orderResponse.initiatorUserID == userObject.userID
    }
}

extension OrderNavigationController: OrderManagerDelegate {
    func orderManager(_ manager: OrderManager, didGetAllOrderData orderData: [OrderResponse]) {
        if let orderResponse = orderData.first { $0.orderID == self.orderResponse.orderID } {
            self.orderResponse = orderResponse
            let joinUsers = orderResponse.joinUserIDs
            Task {
                let users = try await UserManager.shared.getUsers(joinUsers)
                self.viewControllers.forEach {
                    let userObjectsAccessible = $0 as? UserObjectsAccessible
                    userObjectsAccessible?.setUserObjects(users)
                }
            }
        }
    }

    func orderManager (_ manager: OrderManager, didGetOrderResults orderResults: [OrderResults]) {
        self.orderResults = orderResults
    }

    func orderManager(_ manager: OrderManager, didFailWith error: Error) {
        print(error.localizedDescription)
    }
}
