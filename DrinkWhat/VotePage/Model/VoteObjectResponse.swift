//
//  VoteObjectResponse.swift
//  DrinkWhat
//
//  Created by Vickyciou on 2023/6/17.
//

import Foundation

// MARK: - VoteObject

struct VoteObjectResponse: Codable {
    let data: VoteObject
}

struct VoteObject: Codable {
    let state: String
    let roomID: String
    let initiatorUserID: String
    var joinUserIDs: [String]?
    var voteResults: [VoteResult]
}

struct VoteResult: Codable, Equatable {
    let shopObject: ShopObject
    var voteUsersIDs: [String]

    static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.shopObject == rhs.shopObject
    }
}

// MARK: - Shops

struct ShopObject: Codable, Equatable {
    let logoImageURL: String
    let mainImageURL: String
    let name: String
    let id: String
    let menu: [ShopMenu]
}

struct ShopMenu: Codable, Equatable {
    let drinkName: String
    let drinkPrice: [VolumePrice]
}

struct VolumePrice: Codable, Equatable {
    let volume: String
    let price: Int
}

