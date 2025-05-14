import Foundation
import Auth0

enum AuthenticationError: Error {
    case failedToCreateResult
}

protocol Auth0Authentication {
    func login() async throws -> Credentials
    func clearSession() async throws
}

// Default implementation using Auth0.swift
class DefaultAuth0Authentication: Auth0Authentication {
    func login() async throws -> Credentials {
        return try await Auth0.webAuth().start()
    }
    
    func clearSession() async throws {
        try await Auth0.webAuth().clearSession()
    }
} 