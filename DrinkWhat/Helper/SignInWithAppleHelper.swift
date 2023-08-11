//
//  SignInWithAppleHelper.swift
//  DrinkWhat
//
//  Created by Vickyciou on 2023/6/26.
//

import Foundation
import AuthenticationServices
import CryptoKit

struct SignInWithAppleResult {
    let token: String
    let nonce: String
    let name: String?
    let email: String?
}

class SignInWithAppleHelper: NSObject {
    private var currentNonce: String?
    private var completionHandler: ((Result<SignInWithAppleResult, Error>) -> Void)?
    private let viewController: UIViewController

    init(viewController: UIViewController) {
        self.viewController = viewController
        super.init()
    }

    func startSignInWithAppleFlow() async throws -> SignInWithAppleResult {
        try await withCheckedThrowingContinuation { continuation in
            self.startSignInWithAppleFlow { result in
                switch result {
                case .success(let signInAppleResult):
                    continuation.resume(returning: signInAppleResult)
                    return
                case .failure(let error):
                    continuation.resume(throwing: error)
                    return
                }
            }
        }
    }
    func startSignInWithAppleFlow(completion: @escaping (Result<SignInWithAppleResult, Error>) -> Void) {

        let nonce = randomNonceString()
        currentNonce = nonce
        completionHandler = completion

        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        request.nonce = sha256(nonce)

        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = viewController
        authorizationController.performRequests()
    }

    private func randomNonceString(length: Int = 32) -> String {
        precondition(length > 0)
        let charset: [Character] =
        Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
        var result = ""
        var remainingLength = length

        while remainingLength > 0 {
            let randoms: [UInt8] = (0 ..< 16).map { _ in
                var random: UInt8 = 0
                let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
                if errorCode != errSecSuccess {
                    fatalError(
                        "Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)"
                    )
                }
                return random
            }

            randoms.forEach { random in
                if remainingLength == 0 {
                    return
                }

                if random < charset.count {
                    result.append(charset[Int(random)])
                    remainingLength -= 1
                }
            }
        }

        return result
    }

    @available(iOS 13, *)
    private func sha256(_ input: String) -> String {
      let inputData = Data(input.utf8)
      let hashedData = SHA256.hash(data: inputData)
      let hashString = hashedData.compactMap {
        String(format: "%02x", $0)
      }.joined()

      return hashString
    }
}

extension SignInWithAppleHelper: ASAuthorizationControllerDelegate {
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        guard
            let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential,
            let appleIDToken = appleIDCredential.identityToken,
            let idTokenString = String(data: appleIDToken, encoding: .utf8),
            let nonce = currentNonce else {
            completionHandler?(.failure(URLError(.badServerResponse)))
            return
        }
        let name = appleIDCredential.fullName?.givenName
        let email = appleIDCredential.email
        let tokens = SignInWithAppleResult(token: idTokenString, nonce: nonce, name: name, email: email)
        completionHandler?(.success(tokens))
    }

    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        completionHandler?(.failure(URLError(.cannotFindHost)))
    }

}

extension UIViewController: ASAuthorizationControllerPresentationContextProviding {

    public func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
}
