//
//  URLRequest+Utilities.swift
//  
//
//  Created by Stefan Klein Nulent on 05/03/2021.
//

import Foundation

extension URLRequest {
    
    // MARK: - Types
    
    enum Method: String {
        case get = "GET"
        case post = "POST"
    }
    
    
    
    // MARK: - Construction
    
    init(method: Method, url: URL) {
        self.init(url: url)
        httpMethod = method.rawValue
    }
}
