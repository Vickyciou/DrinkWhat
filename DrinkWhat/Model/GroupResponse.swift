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
    var voteResults: [VoteResults]

}

struct VoteResults: Codable, Equatable {
    let shopID: String
    var voteUsersIDs: [String]

    static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.shopID == rhs.shopID
    }
}

//extension Encodable {
//    func toDictionary() throws -> [String: Any] {
//        let data = try JSONEncoder().encode(self)
//        guard let dictionary = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] else {
//            throw NSError(domain: "Invalid JSON data", code: -1, userInfo: nil)
//        }
//        return dictionary
//    }
//}
