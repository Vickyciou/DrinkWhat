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
    let initiatorUser: UserVoteState
    let joinUser: [UserVoteState]
    let voteResult: [VoteResult]
}

// MARK: - User
struct UserVoteState: Codable {
    let userID: String
    let isVote: Bool
}

// MARK: - VoteList
struct VoteResult: Codable {
    let shopObject: ShopObject
    let voteUsers: [String]
}

// MARK: - ShopObject
struct ShopObject: Codable {
    let imageURL: String
    let name: String
    let id: String
}
