//
//  SubredditsPager.swift
//  
//
//  Created by Stefan Klein Nulent on 12/03/2021.
//

import Foundation

public struct SubredditsPager: Decodable {
    
    // MARK: - Properties
    
    public let subreddits: [Subreddit]
    public let before: String?
    public let after: String?
    
    
    
    // MARK: - Construction
    
    // MARK: Decodable Construction
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let data = try container.decode(DataResponse.self)
        
        if case let Thing.listing(listing) = data.thing {
            subreddits = listing.children.compactMap {
                if case let .subreddit(subreddit) = $0 {
                    return subreddit
                } else {
                    return nil
                }
            }
            
            before = listing.before
            after = listing.after
        } else {
            throw DecodingError.dataCorruptedError(in: container, debugDescription: "")
        }
    }
}
