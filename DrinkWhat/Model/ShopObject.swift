//
//  ShopObject.swift
//  DrinkWhat
//
//  Created by Vickyciou on 2023/6/24.
//

import Foundation

struct ShopObject: Codable, Equatable {
    let logoImageURL: String
    let mainImageURL: String
    let name: String
    let id: String
    let menu: [ShopMenu]
    let addToppings: [AddToppings]
}

struct ShopMenu: Codable, Equatable {
    let drinkName: String
    let drinkPrice: [VolumePrice]
}

struct VolumePrice: Codable, Equatable {
    let volume: String
    let price: Int
}

struct AddToppings: Codable, Equatable {
    let topping: String
    let price: Int
}
