//
//  OrderManager.swift
//  DrinkWhat
//
//  Created by Vickyciou on 2023/6/29.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

protocol OrderManagerDelegate: AnyObject {
    func orderManager(_ manager: OrderManager, didGetAllOrderData orderData: [OrderResponse])
    func orderManager(_ manager: OrderManager, didGetOrderResults orderResults: [OrderResults])
    func orderManager(_ manager: OrderManager, didFailWith error: Error)
}

enum OrderStatus: String {
    case active = "進行中"
    case canceled = "已取消"
    case finished = "已完成"
}

class OrderManager {
    weak var delegate: OrderManagerDelegate?
    private let orderCollection: CollectionReference =
    Firestore.firestore().collection("Orders")

    private func orderDocument(orderID: String) -> DocumentReference {
        orderCollection.document(orderID)
    }

    private func orderResultsSubCollection(orderID: String) -> CollectionReference {
        orderDocument(orderID: orderID).collection("OrderResult")
    }

    private func orderObjectsDocument(orderID: String, userID: String) -> DocumentReference {
        orderResultsSubCollection(orderID: orderID).document(userID)
    }
    private var orderResponseListener: ListenerRegistration?

    private var orderResultsListener: ListenerRegistration?

    // MARK: - Create new order
    func createOrder(shopObject: ShopObject, initiatorUserID: String, initiatorUserName: String) async throws -> OrderResponse {

        let document = try await orderCollection.whereFilter(Filter.orFilter(
            [
                Filter.whereField("initiatorUserID", isEqualTo: initiatorUserID),
                Filter.whereField("joinUserIDs", arrayContains: initiatorUserID)
            ]
        )).whereFilter(Filter.whereField("state", isEqualTo: OrderStatus.active.rawValue)).getDocuments()

        if (document.documents.first?.data()) != nil {
            throw ManagerError.itemAlreadyExistsError
        } else {
            let orderID = orderCollection.document().documentID
            let order = OrderResponse(
                orderID: orderID,
                date: Date().timeIntervalSince1970,
                state: OrderStatus.active.rawValue,
                initiatorUserID: initiatorUserID,
                initiatorUserName: initiatorUserName,
                shopObject: shopObject,
                joinUserIDs: [initiatorUserID]
            )
            try orderDocument(orderID: orderID).setData(from: order)
            return order
        }
    }
    // MARK: - remove order
    func removeOrder(orderID: String) {
        orderDocument(orderID: orderID).delete()
    }

    // MARK: - Add order results
    func addOrderResult(userID: String, orderObject: OrderObject, shopID: String) async throws {
        let document = try await orderCollection.whereFilter(Filter.orFilter(
            [
                Filter.whereField("initiatorUserID", isEqualTo: userID),
                Filter.whereField("joinUserIDs", arrayContains: userID)
            ]
        )).whereFilter(Filter.whereField("state", isEqualTo: OrderStatus.active.rawValue)).getDocuments()

        if let order = try document.documents.first?.data(as: OrderResponse.self) {
            if order.shopObject.id == shopID {
                let orderID = order.orderID
                let orderResultRef = orderObjectsDocument(orderID: orderID, userID: userID)
                if let _ = try? await orderResultRef.getDocument().data(as: OrderResults.self) {
                    let orderObjectDic = try orderObject.toDictionary()
                    try await orderResultRef.updateData(["orderObjects": FieldValue.arrayUnion([orderObjectDic])])
                } else {
                    let orderResults = OrderResults(userID: userID, isPaid: false, orderObjects: [orderObject])
                    try orderObjectsDocument(orderID: orderID, userID: userID).setData(from: orderResults)
                }

            } else {
                throw ManagerError.noMatchData
            }
        } else {
            throw ManagerError.noData
        }
    }

    // MARK: - User add into order group
    func addUserIntoOrderGroup(userID: String, orderID: String) async throws {
        let document = try await orderCollection.whereFilter(Filter.orFilter(
            [
                Filter.whereField("initiatorUserID", isEqualTo: userID),
                Filter.whereField("joinUserIDs", arrayContains: userID)
            ]
        )).whereFilter(Filter.whereField("state", isEqualTo: OrderStatus.active.rawValue)).getDocuments()

        if (document.documents.first?.data()) == nil {
            try await orderDocument(orderID: orderID).updateData(["joinUserIDs": FieldValue.arrayUnion([userID])])
        } else if document.documents.first?.data()["initiatorUserID"] as! String == userID {
            throw ManagerError.hadActiveOrderGroup
        } else {
            throw ManagerError.alreadyAddAnotherOrderError
        }
    }

    func addUsers(userIDs: [String], toJoinOrder orderID: String) async throws {
        let usersQuery = try await orderCollection
            .whereField("joinUserIDs", arrayContainsAny: userIDs)
            .whereFilter(Filter.whereField("state", isEqualTo: OrderStatus.active.rawValue))
            .getDocuments()
        var orders: [OrderResponse] = []
        var errors: [Error] = []
        for document in usersQuery.documents {
            do {
                let order = try document.data(as: OrderResponse.self)
                orders.append(order)
            } catch {
                errors.append(error)
            }
        }

        let queryOrderUserIDs = Set(orders.flatMap { $0.joinUserIDs })
        let alreadyInActiveUserIDs = queryOrderUserIDs.intersection(Set(userIDs)) // 交集
        let notActiveUserIDs = Set(userIDs).symmetricDifference(alreadyInActiveUserIDs) // 剩下的

        // Join to order
        try await orderDocument(orderID: orderID)
            .updateData(["joinUserIDs": FieldValue.arrayUnion(Array(notActiveUserIDs))])

        Array(alreadyInActiveUserIDs).forEach {
            print("\($0) is already in active order.")
        }
    }

    // MARK: - Remove user from order group
    func removeUserFromOrder(userID: String, orderID: String) {
        orderDocument(orderID: orderID).updateData(["joinUserIDs": FieldValue.arrayRemove([userID])])
    }

    // MARK: - Closed or cancel order group
    func setOrderStatus(orderID: String, status: String) {
        orderDocument(orderID: orderID).updateData(["state": status])
    }

    // MARK: - Remove orderObject from user orderResults
    func removeOrderObject(userID: String, orderID: String, orderObject: OrderObject) {
        do {
            let orderObjectDic = try orderObject.toDictionary()
            orderObjectsDocument(orderID: orderID, userID: userID)
                .updateData(["orderObjects": FieldValue.arrayRemove([orderObjectDic])])
        } catch {
             print(ManagerError.encodingError)
        }
    }
    // MARK: - update user paid status
    func updatePaidStatusToTrue(orderID: String, userID: String) {
        orderObjectsDocument(orderID: orderID, userID: userID).updateData(["isPaid": true])
    }

    func updatePaidStatusToFalse(orderID: String, userID: String) {
        orderObjectsDocument(orderID: orderID, userID: userID).updateData(["isPaid": false])
    }
    // MARK: - Load order page
    func listenOrderResponse(userID: String) {
        orderResponseListener = orderCollection.whereFilter(Filter.orFilter(
            [
                Filter.whereField("initiatorUserID", isEqualTo: userID),
                Filter.whereField("joinUserIDs", arrayContains: userID)
            ]
        )).addSnapshotListener ({ [weak self] snapshot, error in
            guard let self else { return }
            if let error = error {
                self.delegate?.orderManager(self, didFailWith: error)
            } else if let snapshot {
                let orderData: [OrderResponse] =
                    snapshot.documents.compactMap
                {
                    try? $0.data(as: OrderResponse.self)

                }
                self.delegate?.orderManager(self, didGetAllOrderData: orderData)
            }
        })
    }

    // MARK: - Listen to order results
    func listenOrderResults(orderID: String) {
        orderResultsListener = orderResultsSubCollection(orderID: orderID).addSnapshotListener {
            [weak self] documentSnapshot, error in
            guard let self else { return }
            if let error {
                self.delegate?.orderManager(self, didFailWith: error)
            } else if let documentSnapshot {
                let results = documentSnapshot.documents.compactMap {
                    try? $0.data(as: OrderResults.self)
                }
                self.delegate?.orderManager(self, didGetOrderResults: results)
            }
        }
    }
}
