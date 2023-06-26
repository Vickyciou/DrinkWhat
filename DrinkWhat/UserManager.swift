//
//  UserManager.swift
//  DrinkWhat
//
//  Created by Vickyciou on 2023/6/21.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseAuth

class UserManager {
    static let shared = UserManager()

    private let userCollection: CollectionReference = Firestore.firestore().collection("Users")
    
    private func userDocument(userID: String) -> DocumentReference {
        userCollection.document(userID)
    }

    var userObject: UserObject?

    func createUserData(userObject: UserObject) async throws {
        try userDocument(userID: userObject.userID).setData(from: userObject)
    }

    func getUserData() async throws -> UserObject {
        guard let id = Auth.auth().currentUser?.uid else {
            throw NSError(domain: "", code: 0)
        }
        let object = try await userDocument(userID: id).getDocument(as: UserObject.self)
        userObject = object
        return object

//        let docRef = db.collection("Users").document(userID)
//
//        docRef.getDocument { [self] (document, error) in
//            if let document = document, document.exists {
//                do {
//                    let userData = try document.data(as: UserObject.self)
//                    self.userObject = userData
//                } catch {
//                    print("Error decode user\(userID) from Firestore: \(error)")
//                }
//            } else {
//                print("Error get user\(userID) from Firestore: \(String(describing: error))")
//            }
//        }
    }
}
