//
//  AuthorizationService.swift
//  
//
//  Created by Stefan Klein Nulent on 05/03/2021.
//

import Foundation
import Combine

final class AuthorizationService: Service {
    
    // MARK: - Types

    private enum RemoteAuthorizationError: String {
        case accessDenied = "access_denied"
        case unsupportedResponseType = "unsupported_response_type"
        case invalidScope = "invalid_scope"
        case invalidRequest = "invalid_request"
        case unknown
    }
    
    
    
    // MARK: - Private Properties
    
    private let appIdentifier: String
    private let redirectURI: String
    private var authorizationRequestId: String?
    
    
    
    // MARK: - Properties
    
    // MARK: Service Properties
    
    override var baseURL: URL? {
        "https://www.reddit.com"
    }
    
    
    
    // MARK: - Construction
    
    init(appIdentifier: String, redirectURI: String) {
        self.appIdentifier = appIdentifier
        self.redirectURI = redirectURI
    }
    
    
    
    // MARK: - Functions
    
    func generateAuthorizationURL(scope: [Scope], responseType: ResponseType = .code, duration: TokenDuration = .temporary) -> URL {
        let authorizationURL: URL = "https://www.reddit.com/api/v1/authorize"
        let scope = scope.map{ $0.rawValue }.joined(separator: ",")
        let authorizationRequestId = UUID().uuidString

        var components = URLComponents(url: authorizationURL, resolvingAgainstBaseURL: false)
        components?.queryItems = [
            URLQueryItem(name: "client_id", value: appIdentifier),
            URLQueryItem(name: "response_type", value: responseType.rawValue),
            URLQueryItem(name: "state", value: authorizationRequestId),
            URLQueryItem(name: "redirect_uri", value: redirectURI),
            URLQueryItem(name: "duration", value: duration.rawValue),
            URLQueryItem(name: "scope", value: scope)
        ]
        
        self.authorizationRequestId = authorizationRequestId
        
        if let url = components?.url {
            return url
        } else {
            fatalError("Unable to generate authorization URL")
        }
    }
    
    func handleRedirectURL(_ url: URL) -> AnyPublisher<AccessToken, Error> {
        let components = URLComponents(url: url, resolvingAgainstBaseURL: false)
        
        if let error = handleAuthorizationError(components?.value(for: "error")) {
            return .failure(error)
        } else {
            guard let receivedState = components?.value(for: "state"), receivedState == authorizationRequestId else {
                return .failure(AuthorizationError.invalidState)
            }
            
            guard let code = components?.value(for: "code") else {
                return .failure(AuthorizationError.codeMissing)
            }
            
            return getAccessToken(authorizationCode: code, redirectURI: redirectURI)
        }
    }
    
    func refreshAccessToken(refreshToken: String) -> AnyPublisher<AccessToken, Error> {
        let parameters: [String: String] = [
            "grant_type": GrantType.refreshToken.rawValue,
            "refresh_token": refreshToken
        ]
        
        let body = parameters
            .map{ "\($0)=\(percentEscapeString($1))" }
            .joined(separator: "&")
        
        return post("/api/v1/access_token") {
            body.data(using: .utf8)
        }
    }
    
    
    // MARK: Service Functions
    
    override func prepare(_ request: URLRequest) -> URLRequest {
        var request = super.prepare(request)
        
        let value = "\(appIdentifier):".data(using: .utf8)?.base64EncodedString() ?? ""
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.setValue("Basic \(value)", forHTTPHeaderField: "Authorization")
        
        return request
    }
    
    
    
    // MARK: - Private Functions
    
    private func getAccessToken(authorizationCode: String, redirectURI: String, grantType: GrantType = .authorizationCode) -> AnyPublisher<AccessToken, Error> {
        let parameters: [String: String] = [
            "grant_type": grantType.rawValue,
            "code": authorizationCode,
            "redirect_uri": redirectURI
        ]
        
        let body = parameters
            .map{ "\($0)=\(percentEscapeString($1))" }
            .joined(separator: "&")
        
        return post("/api/v1/access_token") {
            body.data(using: .utf8)
        }
    }
    
    private func percentEscapeString(_ string: String) -> String {
        var characterSet: CharacterSet = .alphanumerics
        characterSet.insert(charactersIn: "-._* ")
        
        return string
            .addingPercentEncoding(withAllowedCharacters: characterSet)!
            .replacingOccurrences(of: " ", with: "+")
    }
    
    private func handleAuthorizationError(_ error: String?) -> AuthorizationError? {
        guard let error = error else { return nil }
        
        let authorizationError = RemoteAuthorizationError(rawValue: error) ?? .unknown
        
        switch authorizationError {
        case .accessDenied:
            return .accessDenied
        case .unsupportedResponseType:
            return .unsupportedResponseType
        case .invalidScope:
            return .invalidScope
        case .invalidRequest:
            return .invalidRequest
        case .unknown:
            return .unknown
        }
    }
}
