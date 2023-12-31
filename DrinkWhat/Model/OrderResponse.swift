//
//  OrderResponse.swift
//  DrinkWhat
//
//  Created by Vickyciou on 2023/6/29.
//

import Foundation

struct OrderResponse: Codable {
    let orderID: String
    let date: Double
    let state: String
    let initiatorUserID: String
    let initiatorUserName: String
    let shopObject: ShopObject
    var joinUserIDs: [String]
}

struct OrderResults: Codable {
    let userID: String
    var isPaid: Bool
    var orderObjects: [OrderObject]
}

struct OrderObject: Codable {
    let drinkName: String
    let drinkPrice: Int
    let volume: String
    let sugar: String
    let ice: String
    let addToppings: [AddTopping]
    let note: String

}

struct AddTopping: Codable {
    let topping: String
    let price: Int
}
