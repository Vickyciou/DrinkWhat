//
//  OrderNavigationController.swift
//  DrinkWhat
//
//  Created by Vickyciou on 2023/7/1.
//

import UIKit

protocol OrderNavigationControllerDelegate: AnyObject {
    func didPressAddItemButton(_ vc: OrderNavigationController, orderResponse: OrderResponse)
}

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
    private let userManager = UserManager()
    weak var orderNavDelegate: OrderNavigationControllerDelegate?
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
    private var joinUserObjects: [UserObject] = [] {
        didSet {
            DispatchQueue.main.async {

                self.viewControllers.forEach {
                    let userObjectsAccessible = $0 as? UserObjectsAccessible
                    userObjectsAccessible?.setUserObjects(self.joinUserObjects)
                }
            }
        }
    }
    private let userObject = UserManager.shared.userObject

    init(orderResponse: OrderResponse) {
        self.orderResponse = orderResponse
        let orderingVC = OrderingViewController(
            orderResponse: orderResponse,
            isInitiator: orderResponse.initiatorUserID == userObject?.userID
        )
        orderingVC.setOrderResults(orderResults)
        orderingVC.setUserObjects(joinUserObjects)
        orderingVC.setOrderResponse(orderResponse)
        super.init(rootViewController: orderingVC)
        orderingVC.delegate = self
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationItem.hidesBackButton = true
        orderManager.delegate = self
        userManager.delegate = self
        orderManager.listenOrderResults(orderID: orderResponse.orderID)
        if let userObject {
            orderManager.listenOrderResponse(userID: userObject.userID)
        }
    }

//    private func decideVC(
//        orderResponse: OrderResponse,
//        joinUserObject: [UserObject],
//        userObject: UserObject,
//        orderResults: [OrderResults]
//    ) {
//        DispatchQueue.main.async { [self] in
//            //        if isEndOrder(orderResponse: orderResponse) {
//            //            if viewControllers.last is OrderResultsViewController { return }
//            //            let orderResultVC = OrderResultsViewController(
//            //                orderResponse: orderResponse,
//            //                joinUserObject: joinUserObject,
//            //                orderResults: orderResults
//            //            )
//            //            pushViewController(orderResultVC, animated: !viewControllers.isEmpty)
//            //        } else {
//            //            if viewControllers.last is OrderingViewController { return }
//            let orderingVC = OrderingViewController(
//                orderResponse: orderResponse,
//                isInitiator: orderResponse.initiatorUserID == userObject.userID
//            )
//            orderingVC.setOrderResults(orderResults)
//            orderingVC.setUserObjects(joinUserObject)
//            orderingVC.setOrderResponse(orderResponse)
//            orderingVC.delegate = self
//            pushViewController(orderingVC, animated: !viewControllers.isEmpty)
//        }
//    }
//    }
//
//    private func isEndOrder(orderResponse: OrderResponse) -> Bool {
//        orderResponse.state == "已完成"
//    }

    private func isInitiator(orderResponse: OrderResponse, userObject: UserObject) -> Bool {
        orderResponse.initiatorUserID == userObject.userID
    }
}

extension OrderNavigationController: OrderManagerDelegate {
    func orderManager(_ manager: OrderManager, didGetAllOrderData orderData: [OrderResponse]) {
        if let orderResponse = orderData.first { $0.orderID == self.orderResponse.orderID } {
            self.orderResponse = orderResponse
        }
    }

    func orderManager (_ manager: OrderManager, didGetOrderResults orderResults: [OrderResults]) {
        self.orderResults = orderResults
        Task {
            try await orderResults
                .map { $0.userID }
                .asyncMap(userManager.getUserData)
//            if let myUserObject = self.userObject {
//                decideVC(orderResponse: orderResponse,
//                         joinUserObject: joinUserObjects,
//                         userObject: myUserObject,
//                         orderResults: orderResults)
//            }
        }
//        if orderResults.isEmpty {
//        }
    }

    func orderManager(_ manager: OrderManager, didFailWith error: Error) {
        print(error.localizedDescription)
    }
}

extension OrderNavigationController: UserManagerDelegate {
    func userManager(_ manager: UserManager, didGet userObject: UserObject) {
        self.joinUserObjects.append(userObject)
//
//        if let myUserObject = self.userObject {
//            decideVC(orderResponse: orderResponse,
//                     joinUserObject: joinUserObjects,
//                     userObject: myUserObject,
//                     orderResults: orderResults)
//        }
    }
}

extension OrderNavigationController: OrderingViewControllerDelegate {
    func didPressAddItemButton(_ vc: OrderingViewController, orderResponse: OrderResponse) {
        orderNavDelegate?.didPressAddItemButton(self, orderResponse: orderResponse)
        dismiss(animated: false)
    }
}

extension Array {
    func asyncMap<T>(_ transform: @escaping (Element) async throws -> T) async throws -> [T] {
        var results: [T] = []
        try await withThrowingTaskGroup(of: T.self) { group in
            for element in self {
                group.addTask {
                    try await transform(element)
                }
            }
            for try await result in group {
                results.append(result)
            }
        }
        return results
    }
}
