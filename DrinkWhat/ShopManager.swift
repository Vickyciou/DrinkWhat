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
                for document in querySnapshot!.documents {
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
            ShopMenu(drinkName: "做嬌玫瑰", drinkPrice: [
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
}
