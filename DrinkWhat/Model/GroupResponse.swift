//
//  GroupResponse.swift
//  DrinkWhat
//
//  Created by Vickyciou on 2023/6/20.
//

import Foundation

struct GroupSetup: Codable {
    let groupID: String
    let date: Double
    let state: String
    let initiatorUserID: String
    let initiatorUserName: String
    let initiatorUserImage: String
    var joinUserIDs: [String]
}

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

extension Encodable {
    func toDictionary() throws -> [String: Any] {
        let data = try JSONEncoder().encode(self)
        guard let dictionary = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] else {
            throw NSError(domain: "Invalid JSON data", code: -1, userInfo: nil)
        }
        return dictionary
    }
}
