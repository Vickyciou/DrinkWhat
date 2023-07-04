//
//  GroupResponse.swift
//  DrinkWhat
//
//  Created by Vickyciou on 2023/6/20.
//

import Foundation

struct GroupResponse: Codable {
    let groupID: String
    let date: Double
    let state: String
    let initiatorUserID: String
    let initiatorUserName: String
    let initiatorUserImage: String
    var joinUserIDs: [String]
}

struct VoteResult: Codable, Equatable {
    let shopID: String
    let userIDs: [String]

    static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.shopID == rhs.shopID
    }
}
