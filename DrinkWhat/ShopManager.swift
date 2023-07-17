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
                guard let querySnapshot else { return }
                for document in querySnapshot.documents {
                    do {
                        let shopObject = try document.data(as: ShopObject.self)
                        shopData.append(shopObject)
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
                } catch {
                    delegate?.shopManager(self, didFailWith: error)
                    print("Error get shop from Firestore: \(error)")
                }
            } else {
                print("Shop\(shopID) document does not exist")
            }
        }
    }

    func getShopObjects(_ shopIDs: [String]) {
        var results: [ShopObject] = []
        let group = DispatchGroup()
        for shopID in shopIDs {
            group.enter()
            db.collection("Shops").document(shopID).getDocument { [weak self] snapshot, error in
                guard let self else {
                    group.leave()
                    return
                }
                if let error {
                    self.delegate?.shopManager(self, didFailWith: error)
                } else if let snapshot {
                    do {
                        let shop = try snapshot.data(as: ShopObject.self)
                        results.append(shop)
                    } catch {
                        self.delegate?.shopManager(self, didFailWith: error)
                    }
                }
                group.leave()
            }
        }
        group.notify(queue: .main) { [weak self] in
            guard let self else { return }
            self.delegate?.shopManager(self, didGetShopData: results)
        }
    }

    func getShopObjects2(_ shopIDs: [String]) {
        let ref = db.collection("Shops")
        ref.whereField("id", in: shopIDs).getDocuments { query, error in
            if let error {
                self.delegate?.shopManager(self, didFailWith: error)
                return
            }
            guard let documents = query?.documents else {
                self.delegate?.shopManager(self, didGetShopData: [])
                return
            }
            var shopObjects: [ShopObject] = []
            var errors: [Error] = []
            for document in documents {
                do {
                    let shopObject = try document.data(as: ShopObject.self)
                    shopObjects.append(shopObject)
                } catch let error {
                    errors.append(error)
                }
            }

            if let firstError = errors.first {
                self.delegate?.shopManager(self, didFailWith: firstError)
            } else {
                self.delegate?.shopManager(self, didGetShopData: shopObjects)
            }
        }
    }
}
extension ShopManager {
    func set50嵐Shop() {

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
            menu: shopMenu,
            addToppings: [])

        self.createShopData(shopObject: shopObjects)
    }
    func set龜記Shop() {

        let shopMenu: [ShopMenu] =
        [
            ShopMenu(drinkName: "極品紅茶", drinkPrice: [
                VolumePrice(volume: "L", price: 30)
            ]),
            ShopMenu(drinkName: "老欉鐵觀音", drinkPrice: [
                VolumePrice(volume: "L", price: 35)
            ]),
            ShopMenu(drinkName: "三韻紅萱", drinkPrice: [
                VolumePrice(volume: "L", price: 40)
            ]),
            ShopMenu(drinkName: "翡翠綠茶", drinkPrice: [
                VolumePrice(volume: "L", price: 30)
            ]),
            ShopMenu(drinkName: "三十三茶王", drinkPrice: [
                VolumePrice(volume: "L", price: 40)
            ]),
            ShopMenu(drinkName: "四季春清茶", drinkPrice: [
                VolumePrice(volume: "L", price: 35)
            ]),
            ShopMenu(drinkName: "紅水烏龍", drinkPrice: [
                VolumePrice(volume: "L", price: 40)
            ]),
            ShopMenu(drinkName: "蜂蜜綠茶", drinkPrice: [
                VolumePrice(volume: "L", price: 45)
            ]),
            ShopMenu(drinkName: "蜂蜜四季春", drinkPrice: [
                VolumePrice(volume: "L", price: 50)
            ]),
            ShopMenu(drinkName: "冬瓜鮮乳", drinkPrice: [
                VolumePrice(volume: "L", price: 65)
            ]),
            ShopMenu(drinkName: "紅烏鮮乳", drinkPrice: [
                VolumePrice(volume: "L", price: 69)
            ]),
            ShopMenu(drinkName: "巧克鮮乳茶", drinkPrice: [
                VolumePrice(volume: "L", price: 69)
            ]),
            ShopMenu(drinkName: "龜記濃乳茶", drinkPrice: [
                VolumePrice(volume: "L", price: 65)
            ]),
            ShopMenu(drinkName: "小農鮮乳茶(紅茶/翡翠/鐵觀音)", drinkPrice: [
                VolumePrice(volume: "L", price: 65)
            ]),
            ShopMenu(drinkName: "秀水旺梨春", drinkPrice: [
                VolumePrice(volume: "L", price: 65)
            ]),
            ShopMenu(drinkName: "阿源楊桃(紅茶/翡翠)", drinkPrice: [
                VolumePrice(volume: "L", price: 55)
            ]),
            ShopMenu(drinkName: "楊桃雷夢", drinkPrice: [
                VolumePrice(volume: "L", price: 60)
            ]),
            ShopMenu(drinkName: "冬瓜雷夢", drinkPrice: [
                VolumePrice(volume: "L", price: 55)
            ]),
            ShopMenu(drinkName: "冬瓜鐵觀音", drinkPrice: [
                VolumePrice(volume: "L", price: 45)
            ]),
            ShopMenu(drinkName: "豆漿紅茶", drinkPrice: [
                VolumePrice(volume: "L", price: 40)
            ]),
            ShopMenu(drinkName: "珍珠奶茶(紅茶/翡翠/鐵觀音)", drinkPrice: [
                VolumePrice(volume: "L", price: 55)
            ]),
            ShopMenu(drinkName: "極品奶茶(紅茶/翡翠/鐵觀音)", drinkPrice: [
                VolumePrice(volume: "L", price: 50)
            ]),
            ShopMenu(drinkName: "黑木耳鮮乳", drinkPrice: [
                VolumePrice(volume: "L", price: 65)
            ]),
            ShopMenu(drinkName: "手作薑茶", drinkPrice: [
                VolumePrice(volume: "L", price: 45)
            ]),
            ShopMenu(drinkName: "桂圓紅棗茶", drinkPrice: [
                VolumePrice(volume: "L", price: 55)
            ]),
            ShopMenu(drinkName: "薑汁奶茶", drinkPrice: [
                VolumePrice(volume: "L", price: 55)
            ]),
            ShopMenu(drinkName: "䉺柚翡翠", drinkPrice: [
                VolumePrice(volume: "L", price: 75)
            ]),
            ShopMenu(drinkName: "金桔拜觀音", drinkPrice: [
                VolumePrice(volume: "L", price: 55)
            ]),
            ShopMenu(drinkName: "鮮果百香(紅茶/翡翠)", drinkPrice: [
                VolumePrice(volume: "L", price: 55)
            ]),
            ShopMenu(drinkName: "翡翠雷夢", drinkPrice: [
                VolumePrice(volume: "L", price: 55)
            ]),
            ShopMenu(drinkName: "香柚雷夢綠", drinkPrice: [
                VolumePrice(volume: "L", price: 69)
            ]),
            ShopMenu(drinkName: "柳丁翡翠", drinkPrice: [
                VolumePrice(volume: "L", price: 55)
            ]),
            ShopMenu(drinkName: "蘋果紅萱", drinkPrice: [
                VolumePrice(volume: "L", price: 59)
            ]),
            ShopMenu(drinkName: "紫葡蘆薈春", drinkPrice: [
                VolumePrice(volume: "L", price: 69)
            ]),
            ShopMenu(drinkName: "蜂蜜雷夢", drinkPrice: [
                VolumePrice(volume: "L", price: 60)
            ]),
            ShopMenu(drinkName: "雷夢蘆薈蜜", drinkPrice: [
                VolumePrice(volume: "L", price: 65)
            ]),
            ShopMenu(drinkName: "玉荷包茶王", drinkPrice: [
                VolumePrice(volume: "L", price: 80)
            ]),
            ShopMenu(drinkName: "薑汁雷夢", drinkPrice: [
                VolumePrice(volume: "L", price: 55)
            ]),
            ShopMenu(drinkName: "薑汁桂圓", drinkPrice: [
                VolumePrice(volume: "L", price: 55)
            ]),
            ShopMenu(drinkName: "擂茶豆漿", drinkPrice: [
                VolumePrice(volume: "L", price: 65)
            ])
        ]

        let shopObjects: ShopObject = ShopObject(
            logoImageURL: "https://firebasestorage.googleapis.com/v0/b/drinkwhat-7702e.appspot.com/o/%E9%BE%9C%E8%A8%98-Logo.jpeg?alt=media&token=19c7cc4d-4cda-4a4e-8678-341a426ed62b",
            mainImageURL: "https://firebasestorage.googleapis.com/v0/b/drinkwhat-7702e.appspot.com/o/%E9%BE%9C%E8%A8%98-%E4%B8%BB%E5%9C%96.jpeg?alt=media&token=b477e372-04d6-4618-ab30-a39744b1fa14",
            name: "龜記茗品",
            id: "uuid002",
            menu: shopMenu,
            addToppings: [
                AddToppings(topping: "珍珠", price: 10),
                AddToppings(topping: "蘆薈", price: 10),
                AddToppings(topping: "椰果", price: 10),
            ])

        self.createShopData(shopObject: shopObjects)
    }
    func set一手私藏Shop() {

        let shopMenu: [ShopMenu] =
        [
            ShopMenu(drinkName: "台灣魚池18號紅玉", drinkPrice: [
                VolumePrice(volume: "L", price: 60)
            ]),
            ShopMenu(drinkName: "私藏仲夏夜紅茶", drinkPrice: [
                VolumePrice(volume: "L", price: 50)
            ]),
            ShopMenu(drinkName: "俄羅斯夏卡爾紅茶", drinkPrice: [
                VolumePrice(volume: "L", price: 50)
            ]),
            ShopMenu(drinkName: "印度阿薩姆琥珀紅茶", drinkPrice: [
                VolumePrice(volume: "L", price: 45)
            ]),
            ShopMenu(drinkName: "英式格雷伯爵紅茶", drinkPrice: [
                VolumePrice(volume: "L", price: 40)
            ]),
            ShopMenu(drinkName: "斯里蘭卡錫蘭紅茶", drinkPrice: [
                VolumePrice(volume: "L", price: 35)
            ]),
            ShopMenu(drinkName: "台灣玉露綠茶", drinkPrice: [
                VolumePrice(volume: "L", price: 35)
            ]),
            ShopMenu(drinkName: "台灣黑金烏龍茶", drinkPrice: [
                VolumePrice(volume: "L", price: 35)
            ]),
            ShopMenu(drinkName: "阿薩姆琥珀茶拿鐵", drinkPrice: [
                VolumePrice(volume: "L", price: 55)
            ]),
            ShopMenu(drinkName: "伯爵茶拿鐵", drinkPrice: [
                VolumePrice(volume: "L", price: 60)
            ]),
            ShopMenu(drinkName: "蜜斯茶拿鐵", drinkPrice: [
                VolumePrice(volume: "L", price: 60)
            ]),
            ShopMenu(drinkName: "錫藺珍珠茶拿鐵", drinkPrice: [
                VolumePrice(volume: "L", price: 65)
            ]),
            ShopMenu(drinkName: "琥珀粉條茶拿鐵", drinkPrice: [
                VolumePrice(volume: "L", price: 70)
            ]),
            ShopMenu(drinkName: "紅玉茶拿鐵", drinkPrice: [
                VolumePrice(volume: "L", price: 75)
            ]),
            ShopMenu(drinkName: "德古拉茶拿鐵", drinkPrice: [
                VolumePrice(volume: "L", price: 75)
            ]),
            ShopMenu(drinkName: "獅子國紅寶石奶茶", drinkPrice: [
                VolumePrice(volume: "L", price: 55)
            ]),
            ShopMenu(drinkName: "珍珠厚黑奶", drinkPrice: [
                VolumePrice(volume: "L", price: 55)
            ]),
            ShopMenu(drinkName: "濃生乳太厚奶茶", drinkPrice: [
                VolumePrice(volume: "L", price: 65)
            ]),
            ShopMenu(drinkName: "黒可可", drinkPrice: [
                VolumePrice(volume: "L", price: 60)
            ]),
            ShopMenu(drinkName: "格雷冰果茶", drinkPrice: [
                VolumePrice(volume: "L", price: 60)
            ]),
            ShopMenu(drinkName: "薔薇果醸紅", drinkPrice: [
                VolumePrice(volume: "L", price: 60)
            ]),
            ShopMenu(drinkName: "半島凍檸茶", drinkPrice: [
                VolumePrice(volume: "L", price: 50)
            ]),
            ShopMenu(drinkName: "青檸玉露綠", drinkPrice: [
                VolumePrice(volume: "L", price: 50)
            ]),
            ShopMenu(drinkName: "檸檬養樂多", drinkPrice: [
                VolumePrice(volume: "L", price: 60)
            ]),
            ShopMenu(drinkName: "夏卡爾多多紅茶", drinkPrice: [
                VolumePrice(volume: "L", price: 65)
            ]),
            ShopMenu(drinkName: "傲嬌玫瑰", drinkPrice: [
                VolumePrice(volume: "L", price: 55)
            ])
        ]

        let shopObjects: ShopObject = ShopObject(
            logoImageURL: "https://firebasestorage.googleapis.com/v0/b/drinkwhat-7702e.appspot.com/o/%E4%B8%80%E6%89%8B%E7%A7%81%E8%97%8F-Logo.jpeg?alt=media&token=981d3314-c5da-4dee-b673-1727dd2fe665",
            mainImageURL: "https://firebasestorage.googleapis.com/v0/b/drinkwhat-7702e.appspot.com/o/%E4%B8%80%E6%89%8B%E7%A7%81%E8%97%8F-%E4%B8%BB%E5%9C%96.jpeg?alt=media&token=5f66fb2f-b3d4-42fd-b7ea-d6a6a60d8f80",
            name: "一手私藏 世界紅茶專賣",
            id: "uuid003",
            menu: shopMenu,
            addToppings: [
                AddToppings(topping: "粉條", price: 15),
                AddToppings(topping: "珍珠", price: 10)
            ])

        self.createShopData(shopObject: shopObjects)
    }


    func set可不可Shop() {

        let shopMenu: [ShopMenu] =
        [
            ShopMenu(drinkName: "熟成紅茶", drinkPrice: [
                VolumePrice(volume: "M", price: 30),
                VolumePrice(volume: "L", price: 35)
            ]),
            ShopMenu(drinkName: "麗春紅茶", drinkPrice: [
                VolumePrice(volume: "M", price: 30),
                VolumePrice(volume: "L", price: 35)
            ]),
            ShopMenu(drinkName: "太妃紅茶", drinkPrice: [
                VolumePrice(volume: "M", price: 35),
                VolumePrice(volume: "L", price: 40)
            ]),
            ShopMenu(drinkName: "胭脂紅茶", drinkPrice: [
                VolumePrice(volume: "M", price: 40),
                VolumePrice(volume: "L", price: 45)
            ]),
            ShopMenu(drinkName: "雪藏紅茶", drinkPrice: [
                VolumePrice(volume: "M", price: 50),
                VolumePrice(volume: "L", price: 60)
            ]),
            ShopMenu(drinkName: "熟成冷露", drinkPrice: [
                VolumePrice(volume: "M", price: 30),
                VolumePrice(volume: "L", price: 35)
            ]),
            ShopMenu(drinkName: "雪花冷露", drinkPrice: [
                VolumePrice(volume: "M", price: 30),
                VolumePrice(volume: "L", price: 35)
            ]),
            ShopMenu(drinkName: "春芽冷露", drinkPrice: [
                VolumePrice(volume: "M", price: 30),
                VolumePrice(volume: "L", price: 35)
            ]),
            ShopMenu(drinkName: "春芽綠茶", drinkPrice: [
                VolumePrice(volume: "M", price: 30),
                VolumePrice(volume: "L", price: 35)
            ]),
            ShopMenu(drinkName: "春梅冰茶", drinkPrice: [
                VolumePrice(volume: "M", price: 40),
                VolumePrice(volume: "L", price: 50)
            ]),
            ShopMenu(drinkName: "冷露歐蕾", drinkPrice: [
                VolumePrice(volume: "M", price: 45),
                VolumePrice(volume: "L", price: 55)
            ]),
            ShopMenu(drinkName: "熟成歐蕾", drinkPrice: [
                VolumePrice(volume: "M", price: 45),
                VolumePrice(volume: "L", price: 55)
            ]),
            ShopMenu(drinkName: "白玉歐蕾", drinkPrice: [
                VolumePrice(volume: "M", price: 55),
                VolumePrice(volume: "L", price: 65)
            ]),
            ShopMenu(drinkName: "熟成檸果", drinkPrice: [
                VolumePrice(volume: "M", price: 55)
            ]),
            ShopMenu(drinkName: "胭脂多多", drinkPrice: [
                VolumePrice(volume: "M", price: 45),
                VolumePrice(volume: "L", price: 55)
            ])
        ]

        let shopObjects: ShopObject = ShopObject(
            logoImageURL: "https://firebasestorage.googleapis.com/v0/b/drinkwhat-7702e.appspot.com/o/shopImage%2F%E5%8F%AF%E4%B8%8D%E5%8F%AF-Logo.jpeg?alt=media&token=f9966410-f06f-4948-a685-55d297add3aa",
            mainImageURL: "https://firebasestorage.googleapis.com/v0/b/drinkwhat-7702e.appspot.com/o/shopImage%2F%E5%8F%AF%E4%B8%8D%E5%8F%AF-%E4%B8%BB%E5%9C%96-1.jpeg?alt=media&token=48801dea-ac2c-4954-91eb-428d3f05e9fe",
            name: "可不可熟成紅茶",
            id: "uuid004",
            menu: shopMenu,
            addToppings: [
                AddToppings(topping: "白玉", price: 10),
                AddToppings(topping: "水玉", price: 10),
                AddToppings(topping: "甜杏", price: 15)
            ])

        self.createShopData(shopObject: shopObjects)
    }

    func set一沐日Shop() {

        let shopMenu: [ShopMenu] =
        [
            ShopMenu(drinkName: "茉莉綠茶", drinkPrice: [
                VolumePrice(volume: "L", price: 30)
            ]),
            ShopMenu(drinkName: "招牌紅茶", drinkPrice: [
                VolumePrice(volume: "L", price: 30)
            ]),
            ShopMenu(drinkName: "炭培烏龍", drinkPrice: [
                VolumePrice(volume: "L", price: 35)
            ]),
            ShopMenu(drinkName: "油切蕎麥茶", drinkPrice: [
                VolumePrice(volume: "L", price: 35)
            ]),
            ShopMenu(drinkName: "手採高山青", drinkPrice: [
                VolumePrice(volume: "L", price: 35)
            ]),
            ShopMenu(drinkName: "日月潭紅茶", drinkPrice: [
                VolumePrice(volume: "L", price: 40)
            ]),
            ShopMenu(drinkName: "愛文芒果冰沙", drinkPrice: [
                VolumePrice(volume: "L", price: 65)
            ]),
            ShopMenu(drinkName: "愛文芒果奶酪", drinkPrice: [
                VolumePrice(volume: "L", price: 65)
            ]),
            ShopMenu(drinkName: "梅果招牌紅", drinkPrice: [
                VolumePrice(volume: "L", price: 50)
            ]),
            ShopMenu(drinkName: "養樂多綠茶", drinkPrice: [
                VolumePrice(volume: "L", price: 50)
            ]),
            ShopMenu(drinkName: "鮮檸檬紅", drinkPrice: [
                VolumePrice(volume: "L", price: 50)
            ]),
            ShopMenu(drinkName: "鮮檸檬青", drinkPrice: [
                VolumePrice(volume: "L", price: 50)
            ]),
            ShopMenu(drinkName: "鮮百香果綠茶", drinkPrice: [
                VolumePrice(volume: "L", price: 65)
            ]),
            ShopMenu(drinkName: "鮮葡萄柚綠茶", drinkPrice: [
                VolumePrice(volume: "L", price: 65)
            ]),
            ShopMenu(drinkName: "荔枝蘆薈", drinkPrice: [
                VolumePrice(volume: "L", price: 60)
            ]),
            ShopMenu(drinkName: "招牌紅奶茶", drinkPrice: [
                VolumePrice(volume: "L", price: 50)
            ]),
            ShopMenu(drinkName: "粉粿黑糖奶茶", drinkPrice: [
                VolumePrice(volume: "L", price: 60)
            ]),
            ShopMenu(drinkName: "黃金蕎麥奶茶", drinkPrice: [
                VolumePrice(volume: "L", price: 50)
            ]),
            ShopMenu(drinkName: "日月潭奶茶", drinkPrice: [
                VolumePrice(volume: "L", price: 60)
            ]),
            ShopMenu(drinkName: "奶酪黑糖奶茶", drinkPrice: [
                VolumePrice(volume: "L", price: 60)
            ]),
            ShopMenu(drinkName: "奶蓋綠茶", drinkPrice: [
                VolumePrice(volume: "L", price: 60)
            ]),
            ShopMenu(drinkName: "奶蓋烏龍茶", drinkPrice: [
                VolumePrice(volume: "L", price: 60)
            ]),
            ShopMenu(drinkName: "奶蓋蕎麥茶", drinkPrice: [
                VolumePrice(volume: "L", price: 60)
            ]),
            ShopMenu(drinkName: "粉粿黑糖檸檬", drinkPrice: [
                VolumePrice(volume: "L", price: 60)
            ]),
            ShopMenu(drinkName: "奶蓋招牌紅茶", drinkPrice: [
                VolumePrice(volume: "L", price: 60)
            ]),
            ShopMenu(drinkName: "荔枝烏龍茶", drinkPrice: [
                VolumePrice(volume: "L", price: 50)
            ]),
            ShopMenu(drinkName: "桂花蕎麥茶", drinkPrice: [
                VolumePrice(volume: "L", price: 50)
            ]),
            ShopMenu(drinkName: "柚子烏龍茶", drinkPrice: [
                VolumePrice(volume: "L", price: 55)
            ]),
            ShopMenu(drinkName: "招牌冬瓜紅", drinkPrice: [
                VolumePrice(volume: "L", price: 40)
            ]),
            ShopMenu(drinkName: "冬瓜青茶", drinkPrice: [
                VolumePrice(volume: "L", price: 45)
            ]),
            ShopMenu(drinkName: "冬瓜檸檬茶", drinkPrice: [
                VolumePrice(volume: "L", price: 45)
            ]),
            ShopMenu(drinkName: "冬瓜仙草蜜", drinkPrice: [
                VolumePrice(volume: "L", price: 45)
            ]),
            ShopMenu(drinkName: "招牌紅拿鐵", drinkPrice: [
                VolumePrice(volume: "L", price: 70)
            ]),
            ShopMenu(drinkName: "烏龍拿鐵", drinkPrice: [
                VolumePrice(volume: "L", price: 70)
            ]),
            ShopMenu(drinkName: "黃金蕎麥拿鐵", drinkPrice: [
                VolumePrice(volume: "L", price: 70)
            ]),
            ShopMenu(drinkName: "日月潭拿鐵", drinkPrice: [
                VolumePrice(volume: "L", price: 80)
            ])
        ]

        let shopObjects: ShopObject = ShopObject(
            logoImageURL: "https://firebasestorage.googleapis.com/v0/b/drinkwhat-7702e.appspot.com/o/shopImage%2F%E4%B8%80%E6%B2%90%E6%97%A5-Logo.jpeg?alt=media&token=cd90e7e9-7b6f-4d5d-ae6b-03c1a0b0e4b8",
            mainImageURL: "https://firebasestorage.googleapis.com/v0/b/drinkwhat-7702e.appspot.com/o/shopImage%2F%E4%B8%80%E6%B2%90%E6%97%A5-%E4%B8%BB%E5%9C%96.jpeg?alt=media&token=7f090c9b-c453-45a1-b83a-21b3076103c9",
            name: "一沐日",
            id: "uuid005",
            menu: shopMenu,
            addToppings: [
                AddToppings(topping: "琥珀粉圓", price: 10),
                AddToppings(topping: "蘆薈", price: 10),
                AddToppings(topping: "嫩仙草", price: 10),
                AddToppings(topping: "招牌粉粿", price: 10),
                AddToppings(topping: "雙粉(粉粿+粉圓)", price: 10),
                AddToppings(topping: "草仔粿", price: 15)
            ])

        self.createShopData(shopObject: shopObjects)
    }

    func set迷客夏Shop() {

        let shopMenu: [ShopMenu] =

        [
            ShopMenu(drinkName: "柚蜜白玉", drinkPrice: [
                VolumePrice(volume: "L", price: 65)
            ]),
            ShopMenu(drinkName: "珍珠紅茶拿鐵", drinkPrice: [
                VolumePrice(volume: "M", price: 55),
                VolumePrice(volume: "L", price: 65)
            ]),
            ShopMenu(drinkName: "檸檬蜜Q晶凍", drinkPrice: [
                VolumePrice(volume: "L", price: 70)
            ]),
            ShopMenu(drinkName: "蜜Q茉香拿鐵", drinkPrice: [
                VolumePrice(volume: "M", price: 80),
                VolumePrice(volume: "L", price: 90)
            ]),
            ShopMenu(drinkName: "珍珠手炒黑糖鮮奶", drinkPrice: [
                VolumePrice(volume: "M", price: 75),
                VolumePrice(volume: "L", price: 95)
            ]),
            ShopMenu(drinkName: "仙草凍冬瓜茶", drinkPrice: [
                VolumePrice(volume: "L", price: 40)
            ]),
            ShopMenu(drinkName: "焙香決明大麥", drinkPrice: [
                VolumePrice(volume: "L", price: 30)
            ]),
            ShopMenu(drinkName: "娜杯紅茶", drinkPrice: [
                VolumePrice(volume: "L", price: 30)
            ]),
            ShopMenu(drinkName: "英倫伯爵紅茶", drinkPrice: [
                VolumePrice(volume: "L", price: 30)
            ]),
            ShopMenu(drinkName: "大正醇香紅茶", drinkPrice: [
                VolumePrice(volume: "L", price: 30)
            ]),
            ShopMenu(drinkName: "原片初露青茶", drinkPrice: [
                VolumePrice(volume: "L", price: 30)
            ]),
            ShopMenu(drinkName: "琥珀高峰烏龍", drinkPrice: [
                VolumePrice(volume: "L", price: 30)
            ]),
            ShopMenu(drinkName: "苿莉原淬綠茶", drinkPrice: [
                VolumePrice(volume: "L", price: 30)
            ]),
            ShopMenu(drinkName: "原鄉冬瓜茶", drinkPrice: [
                VolumePrice(volume: "L", price: 30)
            ]),
            ShopMenu(drinkName: "蜂蜜檸檬晶凍", drinkPrice: [
                VolumePrice(volume: "L", price: 55)
            ]),
            ShopMenu(drinkName: "冰糖洛神梅", drinkPrice: [
                VolumePrice(volume: "L", price: 45)
            ]),
            ShopMenu(drinkName: "冬瓜麥茶", drinkPrice: [
                VolumePrice(volume: "L", price: 45)
            ]),
            ShopMenu(drinkName: "冬瓜檸檬", drinkPrice: [
                VolumePrice(volume: "L", price: 45)
            ]),
            ShopMenu(drinkName: "冬瓜青茶", drinkPrice: [
                VolumePrice(volume: "L", price: 50)
            ]),
            ShopMenu(drinkName: "白甘蔗青茶", drinkPrice: [
                VolumePrice(volume: "L", price: 65)
            ]),
            ShopMenu(drinkName: "養樂多綠", drinkPrice: [
                VolumePrice(volume: "L", price: 50)
            ]),
            ShopMenu(drinkName: "香柚綠茶", drinkPrice: [
                VolumePrice(volume: "L", price: 55)
            ]),
            ShopMenu(drinkName: "冰萃檸檬", drinkPrice: [
                VolumePrice(volume: "L", price: 55)
            ]),
            ShopMenu(drinkName: "冰萃柳丁", drinkPrice: [
                VolumePrice(volume: "L", price: 60)
            ]),
            ShopMenu(drinkName: "青檸香茶", drinkPrice: [
                VolumePrice(volume: "L", price: 65)
            ]),
            ShopMenu(drinkName: "柳丁綠茶／青茶", drinkPrice: [
                VolumePrice(volume: "L", price: 60)
            ]),
            ShopMenu(drinkName: "布朗紅茶拿鐵", drinkPrice: [
                VolumePrice(volume: "M", price: 60),
                VolumePrice(volume: "L", price: 70)
            ]),
            ShopMenu(drinkName: "伯爵可可拿鐵", drinkPrice: [
                VolumePrice(volume: "M", price: 60),
                VolumePrice(volume: "L", price: 70)
            ]),
            ShopMenu(drinkName: "蜂蜜麥茶拿鐵", drinkPrice: [
                VolumePrice(volume: "M", price: 65),
                VolumePrice(volume: "L", price: 75)
            ]),
            ShopMenu(drinkName: "娜杯紅茶拿鐵", drinkPrice: [
                VolumePrice(volume: "M", price: 45),
                VolumePrice(volume: "L", price: 55)
            ]),
            ShopMenu(drinkName: "伯爵紅茶拿鐵", drinkPrice: [
                VolumePrice(volume: "M", price: 45),
                VolumePrice(volume: "L", price: 55)
            ]),
            ShopMenu(drinkName: "大正紅茶拿鐵", drinkPrice: [
                VolumePrice(volume: "M", price: 45),
                VolumePrice(volume: "L", price: 55)
            ]),
            ShopMenu(drinkName: "焙香大麥拿鐵", drinkPrice: [
                VolumePrice(volume: "M", price: 45),
                VolumePrice(volume: "L", price: 55)
            ]),
            ShopMenu(drinkName: "苿香綠茶拿鐵", drinkPrice: [
                VolumePrice(volume: "M", price: 45),
                VolumePrice(volume: "L", price: 55)
            ]),
            ShopMenu(drinkName: "原片青茶拿鐵", drinkPrice: [
                VolumePrice(volume: "M", price: 45),
                VolumePrice(volume: "L", price: 55)
            ]),
            ShopMenu(drinkName: "琥珀烏龍拿鐵", drinkPrice: [
                VolumePrice(volume: "M", price: 45),
                VolumePrice(volume: "L", price: 55)
            ]),
            ShopMenu(drinkName: "醇濃紅茶鮮豆奶（可換茶底）", drinkPrice: [
                VolumePrice(volume: "L", price: 55)
            ]),
            ShopMenu(drinkName: "手炒黑糖鮮奶", drinkPrice: [
                VolumePrice(volume: "M", price: 65)
            ]),
            ShopMenu(drinkName: "嫩仙草凍奶", drinkPrice: [
                VolumePrice(volume: "M", price: 65)
            ]),
            ShopMenu(drinkName: "法芙娜純可可鮮奶", drinkPrice: [
                VolumePrice(volume: "M", price: 65)
            ]),
            ShopMenu(drinkName: "珍珠鮮奶", drinkPrice: [
                VolumePrice(volume: "M", price: 65)
            ]),
            ShopMenu(drinkName: "芋頭鮮奶", drinkPrice: [
                VolumePrice(volume: "M", price: 65)
            ]),
            ShopMenu(drinkName: "綠光鮮奶家庭號", drinkPrice: [
                VolumePrice(volume: "L", price: 169)
            ]),
            ShopMenu(drinkName: "綠光鮮奶小資瓶", drinkPrice: [
                VolumePrice(volume: "L", price: 95)
            ]),
            ShopMenu(drinkName: "小迷無加糖豆漿", drinkPrice: [
                VolumePrice(volume: "L", price: 95)
            ])
        ]

        let shopObjects: ShopObject = ShopObject(
            logoImageURL: "https://firebasestorage.googleapis.com/v0/b/drinkwhat-7702e.appspot.com/o/shopImage%2F%E8%BF%B7%E5%AE%A2%E5%A4%8F-Logo.jpeg?alt=media&token=1c0bd88f-16ef-4482-a072-e239451b4c19",
            mainImageURL: "https://firebasestorage.googleapis.com/v0/b/drinkwhat-7702e.appspot.com/o/shopImage%2F%E8%BF%B7%E5%AE%A2%E5%A4%8F-%E4%B8%BB%E5%9C%96-1.jpeg?alt=media&token=938b2a36-ab82-4cbd-a8b8-df7d23d359f1",
            name: "迷客夏",
            id: "uuid006",
            menu: shopMenu,
            addToppings: [
                AddToppings(topping: "珍珠", price: 10),
                AddToppings(topping: "仙草凍", price: 10),
                AddToppings(topping: "綠茶凍", price: 10),
                AddToppings(topping: "黃金Q角", price: 15),
                AddToppings(topping: "脆啵啵球", price: 15)
            ])

        self.createShopData(shopObject: shopObjects)
    }


}
