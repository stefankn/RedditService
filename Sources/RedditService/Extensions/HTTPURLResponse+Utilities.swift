//
//  HTTPURLResponse+Utilities.swift
//  
//
//  Created by Stefan Klein Nulent on 05/03/2021.
//

import Foundation

extension HTTPURLResponse {
    
    // MARK: - Types
    
    // MARK: - Properties
    
    public var status: HTTPStatus {
        HTTPStatus(statusCode)
    }
}
