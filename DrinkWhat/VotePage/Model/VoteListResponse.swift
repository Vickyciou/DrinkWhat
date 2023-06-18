//
//  VoteListResponse.swift
//  DrinkWhat
//
//  Created by Vickyciou on 2023/6/17.
//

import Foundation

struct VoteListResponse: Codable {
    let data: [VoteList]
}

struct VoteList: Codable {
    let date: Double
    let state: String
    let roomID: String
    let userObject: UserObject
}

struct UserObject: Codable {
    let userID: String
    let userName: String
    let userImageURL: String
}
