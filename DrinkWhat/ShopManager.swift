//
//  ShopManager.swift
//  DrinkWhat
//
//  Created by Vickyciou on 2023/6/22.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

protocol ShopManagerDelegate: AnyObject {
    func shopManager(_ manager: ShopManager, didGetShopData: [ShopObject])
    func shopManager(_ manager: ShopManager, didGetShopObject: ShopObject)
    func shopManager(_ manager: ShopManager, didFailWith error: Error)
}
extension ShopManagerDelegate {
    func shopManager(_ manager: ShopManager, didGetShopData: [ShopObject]){}
    func shopManager(_ manager: ShopManager, didGetShopObject: ShopObject){}
    func shopManager(_ manager: ShopManager, didFailWith error: Error){}
}

class ShopManager {
    private let db = Firestore.firestore()
    weak var delegate: ShopManagerDelegate?

    func createShopData(shopObject: ShopObject) {
        do {
            try db.collection("Shops").document(shopObject.id).setData(from: shopObject)
        } catch {
            print("Error created shop to Firestore: \(error)")
        }
    }

    // MARK: - Get All shop object
    func getAllShopData() {
        var shopData : [ShopObject] = []
        db.collection("Shops").getDocuments() { (querySnapshot, error) in
            if let error = error {
                print("Error getting shops documents: \(error)")
            } else {
                for document in querySnapshot!.documents {
                    do {
                        let shopObject =  try document.data(as: ShopObject.self)
                        shopData.append(shopObject)
                        print("\(document.documentID) => \(document.data())")
                    } catch {
                        print("Error get all shops data from Firestore:\(error)")
                    }
                }
            }
        }
    }
    // MARK: - Get one shop object
    func getShopObject(shopID: String) {
        let docRef = db.collection("Shops").document(shopID)

        docRef.getDocument { [self] (document,error) in
            if let document = document, document.exists {
                do {
                    let shopObject = try document.data(as: ShopObject.self)
                    delegate?.shopManager(self, didGetShopObject: shopObject)
                    print("Document data: \(String(describing: shopObject))")
                } catch {
                    delegate?.shopManager(self, didFailWith: error)
                    print("Error get shop from Firestore: \(error)")
                }
            } else {
                print("Shop\(shopID) document does not exist")
            }
        }
    }
}

