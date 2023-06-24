//
//  UserObject.swift
//  DrinkWhat
//
//  Created by Vickyciou on 2023/6/24.
//

import Foundation

struct UserObject: Codable {
    let userID: String
    let userName: String
    let userImageURL: String
    var favoriteShops: [String]
}
