//
//  AuthManager.swift
//  DrinkWhat
//
//  Created by Vickyciou on 2023/6/26.
//

import Foundation
import FirebaseAuth

struct AuthDataResultModel {
    let uid: String
    let name: String?
    let email: String?
    let photoUrl: String?

    init(user: User, name: String?, email: String?) {
        self.uid = user.uid
        self.email = email
        self.name = name
        self.photoUrl = user.photoURL?.absoluteString
    }
}
final class AuthManager {

    static let shared = AuthManager()
    private init() { }

    func getAuthenticatedUser() throws -> AuthDataResultModel {
        guard let user = Auth.auth().currentUser else {
            throw URLError(.badServerResponse)
        }
        return AuthDataResultModel(user: user, name: user.email, email: user.displayName)
    }

    func signInWithApple(tokens: SignInWithAppleResult) async throws -> AuthDataResultModel {
        let credential = OAuthProvider.credential(withProviderID: "apple.com", idToken: tokens.token, rawNonce: tokens.nonce)
        return try await signIn(
            credential: credential, name: tokens.name, email: tokens.email
        )
    }

    func signIn(credential: AuthCredential, name: String?, email: String?) async throws -> AuthDataResultModel {
        let authDataResult = try await Auth.auth().signIn(with: credential)
        return AuthDataResultModel(user: authDataResult.user, name: name, email: email)
    }

    func signOut() throws {
        try Auth.auth().signOut()
    }

    func delete(credential: Data, authCodeString: String) async throws {
//        try await Auth.auth().revokeToken(withAuthorizationCode: authCodeString)

        Auth.auth().currentUser.reauthenticate(with: credential) { (authResult, error) in
          guard error != nil else { return }
            Task {
                do {
                  try await Auth.auth().revokeToken(withAuthorizationCode: authCodeString)
                    try await user.delete()
                  self.updateUI()
                } catch {
                  self.displayError(error)
                }
              }
        }

        guard let user = Auth.auth().currentUser else {
            throw URLError(.badURL)
        }

        try await user.delete()
    }
}
