//
//  URLComponents+Utilities.swift
//  
//
//  Created by Stefan Klein Nulent on 05/03/2021.
//

import Foundation

extension URLComponents {
    
    // MARK: - Functions
    
    func value(for parameter: String) -> String? {
        queryItems?.first(where: { $0.name == parameter })?.value
    }
}
