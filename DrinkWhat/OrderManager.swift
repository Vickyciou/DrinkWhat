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

    // MARK: - Create new order
    func creatOrder(shopObject: ShopObject, initiatorUserID: String, initiatorUserName: String) async throws {

        let document = try await orderCollection.whereFilter(Filter.andFilter(
            [
                Filter.whereField("initiatorUserID", isEqualTo: initiatorUserID),
                Filter.whereField("state", isEqualTo: OrderStatus.active.rawValue)
            ]
        )).getDocuments()

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
                shopID: shopObject.id,
                shopLogoImageURL: shopObject.logoImageURL,
                shopName: shopObject.name,
                joinUserIDs: []
            )
            try orderDocument(orderID: orderID).setData(from: order)
        }
    }

    // MARK: - Add order results
    func addOrderResult(userID: String, orderObject: OrderObject) async throws {
        let document = try await orderCollection.whereFilter(Filter.orFilter(
            [
                Filter.whereField("initiatorUserID", isEqualTo: userID),
                Filter.whereField("joinUserIDs", arrayContains: userID)
            ]
        )).whereFilter(Filter.whereField("state", isEqualTo: OrderStatus.active.rawValue)).getDocuments()

        if let order = try document.documents.first?.data(as: OrderResponse.self) {
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
            throw ManagerError.noData
        }
    }

    // MARK: - User add into order group
    func addUserIntoOrderGroup(userID: String, orderID: String) {
        orderDocument(orderID: orderID).updateData(["joinUserIDs": FieldValue.arrayUnion([userID])])
    }

    // MARK: - Closed or cancel order group
    func setOrderState(orderID: String, status: String) {
        orderDocument(orderID: orderID).updateData(["state": status])
    }

    // MARK: - Load order page
//    func getOrderResponse(userID: String) {
//        let orders = orderCollection.whereFilter(Filter.orFilter(
//            [
//                Filter.whereField("initiatorUserID", isEqualTo: userID),
//                Filter.whereField("joinUserIDs", arrayContains: userID)
//            ]
//        )).addSnapshotListener ({ [weak self] snapshot, error in
//            guard let self else { return }
//            if let error = error {
//                self.delegate?.orderManager(self, didFailWith: error)
//            } else if let snapshot {
//                let orderData: [OrderResponse] =
//                    snapshot.documents.compactMap
//                {
//                    try? $0.data(as: OrderResponse.self)
//
//                }
//                self.delegate?.orderManager(self, didGetAllOrderData: orderData)
//            }
//        })
//    }
    func getOrderResponse(userID: String) async throws {
        let orders = try await orderCollection.whereFilter(Filter.orFilter(
            [
                Filter.whereField("initiatorUserID", isEqualTo: userID),
                Filter.whereField("joinUserIDs", arrayContains: userID)
            ]
        )).getDocuments()

        do {
            let orderData: [OrderResponse] =
            try orders.documents.compactMap({ try $0.data(as: OrderResponse.self) })
            delegate?.orderManager(self, didGetAllOrderData: orderData)
        } catch {
            print(ManagerError.decodingError)
        }
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
