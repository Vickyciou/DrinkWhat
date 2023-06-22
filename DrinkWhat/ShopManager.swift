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
    func shopManager(_ manager: ShopManager, didGetShopData shopData: [ShopObject])
    func shopManager(_ manager: ShopManager, didGetShopObject shopObject: ShopObject)
    func shopManager(_ manager: ShopManager, didFailWith error: Error)
}
extension ShopManagerDelegate {
    func shopManager(_ manager: ShopManager, didGetShopData shopData: [ShopObject]) {}
    func shopManager(_ manager: ShopManager, didGetShopObject shopObject: ShopObject) {}
    func shopManager(_ manager: ShopManager, didFailWith error: Error) {}
}

class ShopManager {
    static let shared = ShopManager()
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
        var shopData: [ShopObject] = []
        db.collection("Shops").getDocuments() { (querySnapshot, error) in
            if let error = error {
                print("Error getting shops documents: \(error)")
            } else {
                for document in querySnapshot!.documents {
                    do {
                        let shopObject = try document.data(as: ShopObject.self)
                        shopData.append(shopObject)
                        print("\(document.documentID) => \(document.data())")
                    } catch {
                        print("Error get all shops data from Firestore:\(error)")
                    }
                }
                self.delegate?.shopManager(self, didGetShopData: shopData)
            }
        }
    }
    // MARK: - Get one shop object
    func getShopObject(shopID: String) {
        let docRef = db.collection("Shops").document(shopID)

        docRef.getDocument { [self] (document, error) in
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
extension ShopManager {
    func setShops() {

        let shopMenu: [ShopMenu] =
        [
            ShopMenu(drinkName: "茉莉綠茶", drinkPrice: [
                    VolumePrice(volume: "M", price: 30),
                    VolumePrice(volume: "L", price: 35)
                ]),
                ShopMenu(drinkName: "阿薩姆紅茶", drinkPrice: [
                    VolumePrice(volume: "M", price: 30),
                    VolumePrice(volume: "L", price: 35)
                ]),
                ShopMenu(drinkName: "四季春青茶", drinkPrice: [
                    VolumePrice(volume: "M", price: 30),
                    VolumePrice(volume: "L", price: 35)
                ]),
                ShopMenu(drinkName: "黃金烏龍", drinkPrice: [
                    VolumePrice(volume: "M", price: 30),
                    VolumePrice(volume: "L", price: 35)
                ]),
                ShopMenu(drinkName: "椰果紅/綠", drinkPrice: [
                    VolumePrice(volume: "M", price: 35),
                    VolumePrice(volume: "L", price: 45)
                ]),
                ShopMenu(drinkName: "波霸紅/綠", drinkPrice: [
                    VolumePrice(volume: "M", price: 35),
                    VolumePrice(volume: "L", price: 45)
                ]),
                ShopMenu(drinkName: "燕麥紅/綠/青", drinkPrice: [
                    VolumePrice(volume: "M", price: 35),
                    VolumePrice(volume: "L", price: 45)
                ]),
                ShopMenu(drinkName: "微檸檬紅/青", drinkPrice: [
                    VolumePrice(volume: "M", price: 35),
                    VolumePrice(volume: "L", price: 45)
                ]),
                ShopMenu(drinkName: "檸檬綠/青", drinkPrice: [
                    VolumePrice(volume: "M", price: 40),
                    VolumePrice(volume: "L", price: 55)
                ]),
                ShopMenu(drinkName: "梅の綠", drinkPrice: [
                    VolumePrice(volume: "M", price: 40),
                    VolumePrice(volume: "L", price: 55)
                ]),
                ShopMenu(drinkName: "8冰綠/情人茶", drinkPrice: [
                    VolumePrice(volume: "M", price: 40),
                    VolumePrice(volume: "L", price: 55)
                ]),
                ShopMenu(drinkName: "旺來紅/青", drinkPrice: [
                    VolumePrice(volume: "M", price: 40),
                    VolumePrice(volume: "L", price: 55)
                ]),
                ShopMenu(drinkName: "柚子紅/綠", drinkPrice: [
                    VolumePrice(volume: "M", price: 40),
                    VolumePrice(volume: "L", price: 55)
                ]),
                ShopMenu(drinkName: "柚子青/烏", drinkPrice: [
                    VolumePrice(volume: "M", price: 40),
                    VolumePrice(volume: "L", price: 55)
                ]),
                ShopMenu(drinkName: "冰淇淋紅茶", drinkPrice: [
                    VolumePrice(volume: "M", price: 40),
                    VolumePrice(volume: "L", price: 55)
                ]),
                ShopMenu(drinkName: "多多綠/紅", drinkPrice: [
                    VolumePrice(volume: "M", price: 40),
                    VolumePrice(volume: "L", price: 55)
                ]),
                ShopMenu(drinkName: "多多檸檬綠", drinkPrice: [
                    VolumePrice(volume: "M", price: 50),
                    VolumePrice(volume: "L", price: 65)
                ]),
                ShopMenu(drinkName: "奶茶", drinkPrice: [
                    VolumePrice(volume: "M", price: 40),
                    VolumePrice(volume: "L", price: 55)
                ]),
                ShopMenu(drinkName: "奶綠", drinkPrice: [
                    VolumePrice(volume: "M", price: 40),
                    VolumePrice(volume: "L", price: 55)
                ]),
                ShopMenu(drinkName: "烏龍奶", drinkPrice: [
                    VolumePrice(volume: "M", price: 40),
                    VolumePrice(volume: "L", price: 55)
                ]),
                ShopMenu(drinkName: "椰果奶茶", drinkPrice: [
                    VolumePrice(volume: "M", price: 40),
                    VolumePrice(volume: "L", price: 55)
                ]),
                ShopMenu(drinkName: "珍珠奶茶", drinkPrice: [
                    VolumePrice(volume: "M", price: 40),
                    VolumePrice(volume: "L", price: 55)
                ]),
                ShopMenu(drinkName: "波霸奶茶", drinkPrice: [
                    VolumePrice(volume: "M", price: 40),
                    VolumePrice(volume: "L", price: 55)
                ]),
                ShopMenu(drinkName: "燕麥奶茶", drinkPrice: [
                    VolumePrice(volume: "M", price: 40),
                    VolumePrice(volume: "L", price: 55)
                ]),
                ShopMenu(drinkName: "燕麥奶青", drinkPrice: [
                    VolumePrice(volume: "M", price: 40),
                    VolumePrice(volume: "L", price: 55)
                ]),
                ShopMenu(drinkName: "燕麥烏龍奶", drinkPrice: [
                    VolumePrice(volume: "M", price: 40),
                    VolumePrice(volume: "L", price: 55)
                ]),
                ShopMenu(drinkName: "布丁奶茶", drinkPrice: [
                    VolumePrice(volume: "M", price: 50),
                    VolumePrice(volume: "L", price: 65)
                ]),
                ShopMenu(drinkName: "冰淇淋奶茶", drinkPrice: [
                    VolumePrice(volume: "M", price: 50),
                    VolumePrice(volume: "L", price: 65)
                ]),
                ShopMenu(drinkName: "紅茶瑪奇朵", drinkPrice: [
                    VolumePrice(volume: "M", price: 40),
                    VolumePrice(volume: "L", price: 55)
                ]),
                ShopMenu(drinkName: "青茶瑪奇朵", drinkPrice: [
                    VolumePrice(volume: "M", price: 40),
                    VolumePrice(volume: "L", price: 55)
                ]),
                ShopMenu(drinkName: "阿華田", drinkPrice: [
                    VolumePrice(volume: "M", price: 45),
                    VolumePrice(volume: "L", price: 60)
                ]),
                ShopMenu(drinkName: "燕麥阿華田", drinkPrice: [
                    VolumePrice(volume: "M", price: 45),
                    VolumePrice(volume: "L", price: 60)
                ]),
                ShopMenu(drinkName: "可可芭蕾", drinkPrice: [
                    VolumePrice(volume: "M", price: 50),
                    VolumePrice(volume: "L", price: 65)
                ]),
                ShopMenu(drinkName: "紅茶拿鐵", drinkPrice: [
                    VolumePrice(volume: "M", price: 50),
                    VolumePrice(volume: "L", price: 65)
                ]),
                ShopMenu(drinkName: "綠茶拿鐵", drinkPrice: [
                    VolumePrice(volume: "M", price: 50),
                    VolumePrice(volume: "L", price: 65)
                ]),
                ShopMenu(drinkName: "烏龍拿鐵", drinkPrice: [
                    VolumePrice(volume: "M", price: 50),
                    VolumePrice(volume: "L", price: 65)
                ]),
                ShopMenu(drinkName: "珍珠紅茶拿鐵", drinkPrice: [
                    VolumePrice(volume: "M", price: 50),
                    VolumePrice(volume: "L", price: 65)
                ]),
                ShopMenu(drinkName: "波霸紅茶拿鐵", drinkPrice: [
                    VolumePrice(volume: "M", price: 50),
                    VolumePrice(volume: "L", price: 65)
                ]),
                ShopMenu(drinkName: "燕麥紅茶拿鐵", drinkPrice: [
                    VolumePrice(volume: "M", price: 50),
                    VolumePrice(volume: "L", price: 65)
                ]),
                ShopMenu(drinkName: "布丁紅茶拿鐵", drinkPrice: [
                    VolumePrice(volume: "M", price: 55),
                    VolumePrice(volume: "L", price: 75)
                ]),
                ShopMenu(drinkName: "冰淇淋紅茶拿鐵", drinkPrice: [
                    VolumePrice(volume: "M", price: 55),
                    VolumePrice(volume: "L", price: 75)
                ]),
                ShopMenu(drinkName: "阿華田拿鐵", drinkPrice: [
                    VolumePrice(volume: "M", price: 55),
                    VolumePrice(volume: "L", price: 75)
                ]),
                ShopMenu(drinkName: "燕麥阿華田拿鐵", drinkPrice: [
                    VolumePrice(volume: "M", price: 55),
                    VolumePrice(volume: "L", price: 75)
                ]),
                ShopMenu(drinkName: "可可芭蕾拿鐵", drinkPrice: [
                    VolumePrice(volume: "M", price: 55),
                    VolumePrice(volume: "L", price: 75)
                ]),
                ShopMenu(drinkName: "柚子茶", drinkPrice: [
                    VolumePrice(volume: "M", price: 40),
                    VolumePrice(volume: "L", price: 55)
                ]),
                ShopMenu(drinkName: "柚子綠茶", drinkPrice: [
                    VolumePrice(volume: "M", price: 40),
                    VolumePrice(volume: "L", price: 55)
                ]),
                ShopMenu(drinkName: "柚子青茶", drinkPrice: [
                    VolumePrice(volume: "M", price: 40),
                    VolumePrice(volume: "L", price: 55)
                ])
        ]
        let shopObjects: ShopObject = ShopObject(
            logoImageURL: "https://firebasestorage.googleapis.com/v0/b/drinkwhat-7702e.appspot.com/o/50%E5%B5%90.png?alt=media&token=72d2eaaa-663a-4557-9761-263c65550491",
            mainImageURL: "https://firebasestorage.googleapis.com/v0/b/drinkwhat-7702e.appspot.com/o/50%E5%B5%90-%E4%B8%BB%E5%9C%96.png?alt=media&token=7b78f42c-b77f-4ed3-98fb-a1a9e000812a",
            name: "50嵐",
            id: "uuid001",
            menu: shopMenu)

        self.createShopData(shopObject: shopObjects)
    }
}
