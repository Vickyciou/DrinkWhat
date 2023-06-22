//
//  UserManager.swift
//  DrinkWhat
//
//  Created by Vickyciou on 2023/6/21.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

protocol UserManagerDelegate: AnyObject {
    func userManager(_ manager: UserManager, didGet userData: UserObject)
    func userManager(_ manager: UserManager, didFailWith error: Error)
}

class UserManager {
//    static let shared = UserManager()
    private let db = Firestore.firestore()
    weak var delegate: UserManagerDelegate?

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
                    delegate?.userManager(self, didGet: userData)
                    print("Document data: \(String(describing: userData))")
                } catch {
                    delegate?.userManager(self, didFailWith: error)
                    print("Error get user\(userID) from Firestore: \(error)")
                }
            } else {
                print("Document does not exist")
            }
        }
    }
}
