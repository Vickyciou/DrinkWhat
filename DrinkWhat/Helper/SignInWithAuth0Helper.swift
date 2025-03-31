//
//  SignInWithAuth0.swift
//  DrinkWhat
//
//  Created by Vicky on 2025/3/28.
//

import Foundation
import Auth0
import JWTDecode

struct SignInWithAuth0Result {
    let token: String
    let name: String
    let email: String
    let picture: String
}

class SignInWithAuth0Helper: NSObject {
    
    func clearSessionWithAuth0() async throws {
        try await Auth0.webAuth().clearSession()
    }
    
    func loginWithAuth0() async throws -> SignInWithAuth0Result {
        let credentials = try await Auth0
            .webAuth()
            .start()
        guard let result = SignInWithAuth0Result(from: credentials.idToken) else {
            throw AuthenticationError.failedToCreateResult
        }
        return result
    }
}

extension SignInWithAuth0Result {
    init?(from idToken: String) {
        guard let jwt = try? decode(jwt: idToken),
//              let name = jwt["name"].string,
//              let email = jwt["email"].string,
              let picture = jwt["picture"].string  else {
            return nil
        }
        self.token = jwt.string
        self.name = jwt["name"].string ?? ""
        self.email = jwt["email"].string ?? ""
        self.picture = picture
    }
}

enum AuthenticationError: Error {
    case failedToCreateResult
}
