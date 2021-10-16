//
//  AuthorizationError.swift
//  
//
//  Created by Stefan Klein Nulent on 05/03/2021.
//

import Foundation

public enum AuthorizationError: Error {
    case invalidState
    case codeMissing
    case accessDenied
    case unsupportedResponseType
    case invalidScope
    case invalidRequest
    case unknown
}
