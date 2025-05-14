import XCTest
import Auth0
import JWTDecode
@testable import DrinkWhat

final class SignInWithAuth0HelperTests: XCTestCase {
    
    var mockAuth = MockAuth0AuthenticationService()
    lazy var sut = SignInWithAuth0Helper(authenticationService: mockAuth)
    
    // MARK: - SignInWithAuth0Result Tests
    
    func testSignInWithAuth0ResultInitialization_WithValidToken_ShouldSucceed() {
        // Given
        let validToken = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJuYW1lIjoiSm9obiBEb2UiLCJlbWFpbCI6ImpvaG5AZXhhbXBsZS5jb20iLCJwaWN0dXJlIjoiaHR0cHM6Ly9leGFtcGxlLmNvbS9waWN0dXJlLmpwZyJ9.SflKxwRJSMeKKF2QT4fwpMeJf36POk6yJV_adQssw5c"
        
        // When
        let result = SignInWithAuth0Result(from: validToken)
        
        // Then
        XCTAssertNotNil(result)
        XCTAssertEqual(result?.name, "John Doe")
        XCTAssertEqual(result?.email, "john@example.com")
        XCTAssertEqual(result?.picture, "https://example.com/picture.jpg")
        XCTAssertEqual(result?.token, validToken)
    }
    
    func testSignInWithAuth0ResultInitialization_WithInvalidToken_ShouldReturnNil() {
        // Given
        let invalidToken = "invalid.token.string"
        
        // When
        let result = SignInWithAuth0Result(from: invalidToken)
        
        // Then
        XCTAssertNil(result)
    }
    
    func testSignInWithAuth0ResultInitialization_WithMissingPicture_ShouldReturnNil() {
        // Given
        let tokenWithoutPicture = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJuYW1lIjoiSm9obiBEb2UiLCJlbWFpbCI6ImpvaG5AZXhhbXBsZS5jb20ifQ.SflKxwRJSMeKKF2QT4fwpMeJf36POk6yJV_adQssw5c"
        
        // When
        let result = SignInWithAuth0Result(from: tokenWithoutPicture)
        
        // Then
        XCTAssertNil(result)
    }
    
    func testSignInWithAuth0ResultInitialization_WithOptionalFields_ShouldSucceed() {
        // Given
        let tokenWithOptionalFields = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJwaWN0dXJlIjoiaHR0cHM6Ly9leGFtcGxlLmNvbS9waWN0dXJlLmpwZyJ9.SflKxwRJSMeKKF2QT4fwpMeJf36POk6yJV_adQssw5c"
        
        // When
        let result = SignInWithAuth0Result(from: tokenWithOptionalFields)
        
        // Then
        XCTAssertNotNil(result)
        XCTAssertEqual(result?.name, "")
        XCTAssertEqual(result?.email, "")
        XCTAssertEqual(result?.picture, "https://example.com/picture.jpg")
    }
    
    // MARK: - Auth0 Login Tests
    
    func testLoginWithAuth0_Success() async throws {
        // Given
        let validToken = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJuYW1lIjoiSm9obiBEb2UiLCJlbWFpbCI6ImpvaG5AZXhhbXBsZS5jb20iLCJwaWN0dXJlIjoiaHR0cHM6Ly9leGFtcGxlLmNvbS9waWN0dXJlLmpwZyJ9.SflKxwRJSMeKKF2QT4fwpMeJf36POk6yJV_adQssw5c"
        let mockCredentials = Credentials.mockCredentials(idToken: validToken)
        mockAuth.credentials = mockCredentials
        mockAuth.shouldSucceed = true
        
        // When
        let result = try await sut.loginWithAuth0()
        
        // Then
        XCTAssertEqual(result.name, "John Doe")
        XCTAssertEqual(result.email, "john@example.com")
        XCTAssertEqual(result.picture, "https://example.com/picture.jpg")
        XCTAssertEqual(result.token, validToken)
    }
    
    func testLoginWithAuth0_FailureWithInvalidCredentials() async {
        // Given
        mockAuth.shouldSucceed = false
        mockAuth.error = Auth0AuthenticationError.failedToCreateResult
        
        // When/Then
        do {
            _ = try await sut.loginWithAuth0()
            XCTFail("Expected login to fail")
        } catch {
            XCTAssertTrue(error is Auth0AuthenticationError)
            XCTAssertEqual(error as? Auth0AuthenticationError, .failedToCreateResult)
        }
    }
    
    func testLoginWithAuth0_FailureWithInvalidToken() async {
        // Given
        let invalidToken = "invalid.token"
        let mockCredentials = Credentials.mockCredentials(idToken: invalidToken)
        mockAuth.credentials = mockCredentials
        mockAuth.shouldSucceed = true
        
        // When/Then
        do {
            _ = try await sut.loginWithAuth0()
            XCTFail("Expected login to fail")
        } catch {
            XCTAssertTrue(error is Auth0AuthenticationError)
            XCTAssertEqual(error as? Auth0AuthenticationError, .failedToCreateResult)
        }
    }
    
    // MARK: - Clear Session Tests
    
    func testClearSessionWithAuth0_Success() async throws {
        // Given
        mockAuth.shouldSucceed = true
        
        // When/Then
        do {
            try await sut.clearSessionWithAuth0()
        } catch {
            XCTFail("Expected clear session to succeed but got error: \(error)")
        }
    }
    
    func testClearSessionWithAuth0_Failure() async {
        // Given
        mockAuth.shouldSucceed = false
        mockAuth.error = Auth0AuthenticationError.failedToCreateResult
        
        // When/Then
        do {
            try await sut.clearSessionWithAuth0()
            XCTFail("Expected clear session to fail")
        } catch {
            XCTAssertTrue(error is Auth0AuthenticationError)
            XCTAssertEqual(error as? Auth0AuthenticationError, .failedToCreateResult)
        }
    }
} 
