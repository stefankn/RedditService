//
//  AccessToken.swift
//  
//
//  Created by Stefan Klein Nulent on 05/03/2021.
//

import Foundation

public struct AccessToken: Codable {
    
    // MARK: - Types
    
    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case tokenType = "token_type"
        case expiresIn = "expires_in"
        case scope
        case refreshToken = "refresh_token"
    }
    
    
    
    // MARK: - Properties
    
    public let accessToken: String
    public let tokenType: String
    public let expiresIn: Int
    public let scope: String
    public let refreshToken: String?
}
