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

protocol UserObjectsAccessible {
    func setUserObjects(_ userObjects: [UserObject])
}

class OrderNavigationController: UINavigationController {
    private let orderManager = OrderManager()
    private let userManager = UserManager()
    private let orderResponse: OrderResponse
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
        super.init(nibName: nil, bundle: nil)
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
    }

    private func decideVC(
        orderResponse: OrderResponse,
        joinUserObject: [UserObject],
        userObject: UserObject,
        orderResults: [OrderResults]
    ) {
        if isEndOrder(orderResponse: orderResponse) {
            if viewControllers.last is OrderResultsViewController { return }
            let orderResultVC = OrderResultsViewController(
                orderResponse: orderResponse,
                joinUserObject: joinUserObject,
                orderResults: orderResults
            )
            pushViewController(orderResultVC, animated: !viewControllers.isEmpty)
        } else {
            if viewControllers.last is OrderingViewController { return }
            let orderingVC = OrderingViewController(
                orderResponse: orderResponse,
                isInitiator: orderResponse.initiatorUserID == userObject.userID
            )
            orderingVC.setOrderResults(orderResults)
            orderingVC.setUserObjects(joinUserObject)
//            orderingVC.delegate = self
            pushViewController(orderingVC, animated: !viewControllers.isEmpty)
        }
    }

    private func isEndOrder(orderResponse: OrderResponse) -> Bool {
        orderResponse.state == "已完成"
    }

    private func isInitiator(orderResponse: OrderResponse, userObject: UserObject) -> Bool {
        orderResponse.initiatorUserID == userObject.userID
    }
}

extension OrderNavigationController: OrderManagerDelegate {
    func orderManager(_ manager: OrderManager, didGetAllOrderData orderData: [OrderResponse]) {
        return
    }

    func orderManager (_ manager: OrderManager, didGetOrderResults orderResults: [OrderResults]) {
        self.orderResults = orderResults
        orderManager.listenOrderResults(orderID: orderResponse.orderID)
        Task {
            let userIDs = try await orderResults
                .map { $0.userID }
                .asyncMap(userManager.getUserData)
        }

        if let userObject {
            decideVC(orderResponse: orderResponse,
                     joinUserObject: joinUserObjects,
                     userObject: userObject,
                     orderResults: orderResults)
        }
    }

    func orderManager(_ manager: OrderManager, didFailWith error: Error) {
        print(error.localizedDescription)
    }
}

extension OrderNavigationController: UserManagerDelegate {
    func userManager(_ manager: UserManager, didGet userObject: UserObject) {
        self.joinUserObjects.append(userObject)
    }
}


//extension VoteNavigationController: VotingViewControllerDelegate {
//    func votingViewController(_ vc: VotingViewController, didPressEndVoteButton button: UIButton) {
//        groupManager.setVoteStateToFinish(groupID: groupID)
//    }
//}

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
