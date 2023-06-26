//
//  UserObject.swift
//  DrinkWhat
//
//  Created by Vickyciou on 2023/6/24.
//

import Foundation

struct UserObject: Codable {
    let userID: String
    let userName: String?
    let email: String?
    let userImageURL: String?
    var favoriteShops: [String]

    init(auth: AuthDataResultModel) {
        self.userID = auth.uid
        self.userName = auth.name
        self.email = auth.email
        self.userImageURL = auth.photoUrl
        self.favoriteShops = []
    }
}
