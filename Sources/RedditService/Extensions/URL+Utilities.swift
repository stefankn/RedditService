//
//  URL+Utilities.swift
//  
//
//  Created by Stefan Klein Nulent on 05/03/2021.
//

import Foundation

extension URL: ExpressibleByStringLiteral {
    
    // MARK: - Construction
    
    // MARK: ExpressibleByStringLiteral Construction
    
    public init(stringLiteral value: String) {
        if let url = URL(string: value) {
            self = url
        } else {
            fatalError("Invalid URL")
        }
    }
    
}
