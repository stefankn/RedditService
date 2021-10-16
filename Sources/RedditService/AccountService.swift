//
//  AccountService.swift
//  
//
//  Created by Stefan Klein Nulent on 06/03/2021.
//

import Foundation
import Combine

final class AccountService: RedditService {
    
    // MARK: - Functions
    
    func getIdentitity() -> AnyPublisher<Identity, Error> {
        get("/api/v1/me")
    }
}
