//
//  UserManager.swift
//  DrinkWhat
//
//  Created by Vickyciou on 2023/6/21.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

class UserManager {
    static let shared = UserManager()
    private let db = Firestore.firestore()
    var userObject: UserObject?

    func createUserData(userObject: UserObject) {
        do {
            try db.collection("Users").document(userObject.userID).setData(from: userObject)
        } catch {
            print("Error created user to Firestore: \(error)")
        }
    }

    func getUserData(userID: String) {
        let docRef = db.collection("Users").document(userID)

        docRef.getDocument { [self] (document,error) in
            if let document = document, document.exists {
                do {
                    let userData = try document.data(as: UserObject.self)
                    self.userObject = userData
                } catch {
                    print("Error decode user\(userID) from Firestore: \(error)")
                }
            } else {
                print("Error get user\(userID) from Firestore: \(String(describing: error))")
            }
        }
    }
}
