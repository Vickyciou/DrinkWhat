//
//  SignInWithAuth0.swift
//  DrinkWhat
//
//  Created by Vicky on 2025/3/28.
//

import Foundation
import Auth0
import JWTDecode

protocol Auth0AuthenticationService {
    func login() async throws -> Credentials
    func clearSession() async throws
}

// Default implementation using Auth0.swift
class DefaultDrinkWhatAuthenticationService: Auth0AuthenticationService {
    func login() async throws -> Credentials {
        return try await Auth0.webAuth().start()
    }
    
    func clearSession() async throws {
        try await Auth0.webAuth().clearSession()
    }
}

struct SignInWithAuth0Result {
    let token: String
    let name: String
    let email: String
    let picture: String
}

class SignInWithAuth0Helper: NSObject {
    private let authenticationService: Auth0AuthenticationService
    
    init(authenticationService: Auth0AuthenticationService? = nil) {
        self.authenticationService = authenticationService ?? DefaultDrinkWhatAuthenticationService()
    }
    
    func clearSessionWithAuth0() async throws {
        try await authenticationService.clearSession()
    }
    
    func loginWithAuth0() async throws -> SignInWithAuth0Result {
        let credentials = try await authenticationService.login()
        guard let result = SignInWithAuth0Result(from: credentials.idToken) else {
            throw Auth0AuthenticationError.failedToCreateResult
        }
        return result
    }
}

extension SignInWithAuth0Result {
    init?(from idToken: String) {
        guard let jwt = try? decode(jwt: idToken),
              let picture = jwt["picture"].string else {
            return nil
        }
        self.token = idToken
        self.name = jwt["name"].string ?? ""
        self.email = jwt["email"].string ?? ""
        self.picture = picture
    }
}

enum Auth0AuthenticationError: Error {
    case failedToCreateResult
}
