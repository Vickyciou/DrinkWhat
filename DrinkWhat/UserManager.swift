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

protocol UserManagerDelegate: AnyObject {
    func userManager(_ manager: UserManager, didGet userObject: UserObject)
}
class UserManager {
    static let shared = UserManager()
    var userObject: UserObject?
    weak var delegate: UserManagerDelegate?

    private let userCollection: CollectionReference = Firestore.firestore().collection("Users")

    private func userDocument(userID: String) -> DocumentReference {
        userCollection.document(userID)
    }

    func loadCurrentUser() async throws {
        let authDataResult = try AuthManager.shared.getAuthenticatedUser()
        self.userObject = try await getUserData(userId: authDataResult.uid)
    }

    func createUserData(userObject: UserObject) async throws {
        try userDocument(userID: userObject.userID).setData(from: userObject, merge: true)
    }

    func getUserData(userId: String) async throws -> UserObject {
        let userObject = try await userDocument(userID: userId).getDocument(as: UserObject.self)
        self.userObject = userObject
        delegate?.userManager(self, didGet: userObject)
        return userObject
    }

    func checkCurrentUser() {

    }

    func signOut() {

    }

    func deleteUser() {
        
    }

}
