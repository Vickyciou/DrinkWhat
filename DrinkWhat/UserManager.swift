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

enum UserManagerError: LocalizedError {
    case noCurrentUser, failWithSignOut, decodingError

    var errorDescription: String? {
        switch self {
        case .noCurrentUser: return "No current user"
        case .failWithSignOut: return "Fail with sign out"
        case .decodingError: return "Decoding userObject error"
        }
    }
}

class UserManager {
    static let shared = UserManager()
    let authManager = AuthManager()
    private var userObject: UserObject?

    private init() {} 

    private let userCollection: CollectionReference = Firestore.firestore().collection("Users")

    private func userDocument(userID: String) -> DocumentReference {
        userCollection.document(userID)
    }

    func loadCurrentUser() async throws -> UserObject {
        if let userObject {
            return userObject
        } else {
            do {
                let authDataResult = try authManager.getAuthenticatedUser()
                let userObject = try await getUserData(userId: authDataResult.uid)
                self.userObject = userObject
                return userObject
            } catch let error as URLError {
                throw error
            } catch {
                throw UserManagerError.noCurrentUser
            }
        }
    }

    func createUserData(userObject: UserObject) async throws {
        try userDocument(userID: userObject.userID).setData(from: userObject, merge: true)
    }

    func getUserData(userId: String) async throws -> UserObject {
        let userObject = try await userDocument(userID: userId).getDocument(as: UserObject.self)
        self.userObject = userObject
        return userObject
    }

    func updateUserImage(userID: String, imageURL: String) {
        userDocument(userID: userID).updateData(["userImageURL": imageURL])
        Task {
            try await self.getUserData(userId: userID)
        }
    }

    func checkCurrentUser() throws -> AuthDataResultModel {
        guard let user = try? authManager.getAuthenticatedUser() else { throw UserManagerError.noCurrentUser
        }
        return user

    }

    func signInWithApple(tokens: SignInWithAppleResult) async throws -> AuthDataResultModel {
        try await authManager.signInWithApple(tokens: tokens)
    }
    
    func signInWithAuth0(tokens: SignInWithAuth0Result) async throws -> AuthDataResultModel {
        try await authManager.signInWithAuth0(tokens: tokens)
    }

    func signOut() {
        do {
            try authManager.signOut()
            userObject = nil
        } catch {
            print(ManagerError.serverError)
        }
    }

    func deleteUser(tokens: DeleteWithAppleResult) async throws {
        try await authManager.delete(tokens: tokens)
    }

    func getUsers(_ userIDs: [String]) async throws -> [UserObject] {
        let query = try await userCollection.whereField("userID", in: userIDs).getDocuments()
        var userObjects: [UserObject] = []
        var errors: [Error] = []
        for document in query.documents {
            do {
                let userObject = try document.data(as: UserObject.self)
                userObjects.append(userObject)
            } catch let error {
                errors.append(error)
            }
        }
        if let firstError = errors.first {
            throw firstError
        } else {
            return userObjects
        }
    }
}
