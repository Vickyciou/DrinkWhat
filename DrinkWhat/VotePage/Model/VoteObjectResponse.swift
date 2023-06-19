//
//  VoteObjectResponse.swift
//  DrinkWhat
//
//  Created by Vickyciou on 2023/6/17.
//

import Foundation

// MARK: - VoteObjectResponse
struct VoteObjectResponse: Codable {
    let data: VoteObject
}

// MARK: - DataClass
struct VoteObject: Codable {
    let state: String
    let roomID: String
    let initiatorUserID: String
    let joinUserIDs: [String]
    var voteResults: [VoteResult]
}

// MARK: - VoteResult
struct VoteResult: Codable, Equatable {
    let shopObject: ShopObject
    let voteUsersIDs: [String]

    static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.shopObject == rhs.shopObject
    }
}

// MARK: - ShopObject
struct ShopObject: Codable, Equatable {
    let imageURL: String
    let name: String
    let id: String
}
