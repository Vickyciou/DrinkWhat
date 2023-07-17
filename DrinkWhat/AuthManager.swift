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

    func getAuthenticatedUser() throws -> AuthDataResultModel {
        guard let user = Auth.auth().currentUser else {
            throw UserManagerError.noCurrentUser
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

    func delete(tokens: DeleteWithAppleResult) async throws {
        guard let user = Auth.auth().currentUser else {
            throw URLError(.badURL)
        }
        let credential = OAuthProvider.credential(withProviderID: "apple.com", idToken: tokens.token, rawNonce: tokens.nonce)
        Auth.auth().currentUser?.reauthenticate(with: credential) { (_, error) in
            guard error == nil else
            { print(URLError.clientCertificateRejected)
                return }
            Task {
                do {
                    // TODO: delete firestore UserObject
                    try await Auth.auth().revokeToken(withAuthorizationCode: tokens.authCode)
                    try await user.delete()
                } catch {
                    print("revoke error")
                }
            }
        }
    }
}
