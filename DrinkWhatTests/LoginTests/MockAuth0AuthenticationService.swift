import Foundation
import Auth0
@testable import DrinkWhat

class MockAuth0AuthenticationService: Auth0AuthenticationService {
    var shouldSucceed: Bool
    var credentials: Credentials?
    var error: Error?
    
    init(shouldSucceed: Bool = true, credentials: Credentials? = nil, error: Error? = nil) {
        self.shouldSucceed = shouldSucceed
        self.credentials = credentials
        self.error = error
    }
    
    func login() async throws -> Credentials {
        if shouldSucceed, let credentials = credentials {
            return credentials
        }
        throw error ?? Auth0AuthenticationError.failedToCreateResult
    }
    
    func clearSession() async throws {
        if !shouldSucceed {
            throw error ?? Auth0AuthenticationError.failedToCreateResult
        }
    }
}

// Mock Credentials for testing
extension Credentials {
    static func mockCredentials(idToken: String) -> Credentials {
        return Credentials(
            accessToken: "mock_access_token",
            tokenType: "Bearer",
            idToken: idToken,
            refreshToken: nil,
            expiresIn: Date().addingTimeInterval(3600),
            scope: "openid profile email"
        )
    }
}
