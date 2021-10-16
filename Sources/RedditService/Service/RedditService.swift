//
//  RedditService.swift
//  
//
//  Created by Stefan Klein Nulent on 06/03/2021.
//

import Foundation
import Combine

class RedditService: Service {
    
    // MARK: - Types
    
    public enum ServiceError: Error {
        case authorizationRequired
    }
    
    
    
    // MARK: - Private Properties
    
    private let accessToken: AccessToken?
    
    
    
    // MARK: - Properties
    
    // MARK: Service Properties
    
    override var baseURL: URL? {
        "https://oauth.reddit.com"
    }
    
    
    
    // MARK: - Construction
    
    init(accessToken: AccessToken?) {
        self.accessToken = accessToken
        super.init()
    }
    
    
    
    // MARK: - Function
    
    func createPagerParameters(after: String?, before: String?, count: Int?, limit: Int?) -> Parameters? {
        var parameters = Parameters()
        
        if let after = after {
            parameters.append((name: "after", value: after))
        }
        
        if let before = before {
            parameters.append((name: "before", value: before))
        }
        
        if let count = count {
            parameters.append((name: "count", value: count))
        }
        
        if let limit = limit {
            parameters.append((name: "limit", value: limit))
        }
        
        return !parameters.isEmpty ? parameters : nil
    }
    
    
    // MARK: Service Functions
    
    override func request<R>(_ request: URLRequest) -> AnyPublisher<R, Error> where R : Decodable {
        guard let accessToken = accessToken else {
            return Fail(error: ServiceError.authorizationRequired).eraseToAnyPublisher()
        }
        
        print(accessToken)

        var request = request
        request.setValue("Bearer \(accessToken.accessToken)", forHTTPHeaderField: "Authorization")

        return super.request(request)
    }
}
