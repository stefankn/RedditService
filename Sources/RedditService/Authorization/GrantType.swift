//
//  GrantType.swift
//  
//
//  Created by Stefan Klein Nulent on 05/03/2021.
//

import Foundation

enum GrantType: String {
    case authorizationCode = "authorization_code"
    case refreshToken = "refresh_token"
    case password = "password"
}
