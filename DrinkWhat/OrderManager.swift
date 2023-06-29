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
    func orderManager(_ manager: OrderManager, didGetAllOrderData orderData:[OrderResponse])
    func orderManager(_ manager: OrderManager, didGetOrderResults orderResults: [OrderResults])
    func orderManager(_ manager: OrderManager, didFailWith error: Error)
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

    // MARK: - Create new order
    func creatOrder(shopID: String, shopName: String, initiatorUserID: String, initiatorUserName: String) async throws {
        //if Order exist
        let document = try await orderCollection.whereFilter(Filter.andFilter(
            [
                Filter.whereField("initiatorUserID", isEqualTo: initiatorUserID),
                Filter.whereField("state", isEqualTo: "進行中")
            ]
        )).getDocuments()
        if (document.documents.first?.data()) != nil {
            throw ManagerError.itemAlreadyExistsError
        } else {
            let orderID = orderCollection.document().documentID
            let order = OrderResponse(
                orderID: orderID,
                date: Date().timeIntervalSince1970,
                state: "進行中",
                initiatorUserID: initiatorUserID,
                initiatorUserName: initiatorUserName,
                shopID: shopID,
                shopName: shopName,
                joinUserIDs: []
            )
            try orderDocument(orderID: orderID).setData(from: order)
        }
    }

    // MARK: - Add order results
    func addOrderResult(userID: String, orderID: String, drinkName: String, drinkPrice: Int, volume: String, sugar: String, ice: String, addToppings: [AddTopping], note: String) async throws {
        let orderObject = OrderObject(
            drinkName: drinkName, drinkPrice: drinkPrice, volume: volume, sugar: sugar, ice: ice, addToppings: addToppings, note: note)
        try orderObjectsDocument(orderID: orderID, userID: userID).setData(from: orderObject, merge: true)
    }

    // MARK: - User add into order group
    func addUserIntoOrderGroup(userID: String, orderID: String) async throws {
        try await orderDocument(orderID: orderID).updateData(["joinUserIDs": FieldValue.arrayUnion([userID])])
    }

    // MARK: - Closed order group
    func setOrderStateToFinish(orderID: String) {
        orderDocument(orderID: orderID).updateData(["state": "已完成"])
    }

    // MARK: - Load order page
    func getOrderResponse(userID: String) async throws {
        let orders = try await orderCollection.whereFilter(Filter.andFilter(
            [
                Filter.whereField("initiatorUserID", isEqualTo: userID),
                Filter.whereField("joinUserIDs", arrayContains: userID)
            ]
        )).getDocuments()

        let orderData: [OrderResponse] =
        orders.documents.compactMap({ try? $0.data(as: OrderResponse.self) })

        delegate?.orderManager(self, didGetAllOrderData: orderData)
    }

    // MARK: - Listen to order results
    func listenOrderResults(orderID: String) {
        orderResultsSubCollection(orderID: orderID).addSnapshotListener {
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
