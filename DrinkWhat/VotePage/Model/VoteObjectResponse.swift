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
    let joinUserID: [String]
    var voteResult: [VoteResult]
}

// MARK: - VoteResult
struct VoteResult: Codable {
    let shopObject: ShopObject
    let voteUsersID: [String]
}

// MARK: - ShopObject
struct ShopObject: Codable {
    let imageURL: String
    let name: String
    let id: String
}
