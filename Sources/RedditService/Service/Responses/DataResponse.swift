//
//  DataResponse.swift
//  
//
//  Created by Stefan Klein Nulent on 07/03/2021.
//

import Foundation

struct DataResponse: Decodable {
    
    // MARK: - Types
    
    enum CodingKeys: String, CodingKey {
        case kind
        case data
    }
    
    

    // MARK: - Properties
    
    let thing: Thing
    
    
    
    // MARK: - Construction
    
    // MARK: Decodable Construction
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let kind = try container.decode(Kind.self, forKey: .kind)
        
        switch kind {
        case .comment:
            thing = .comment(try container.decode(Comment.self, forKey: .data))
        case .account:
            thing = .account(try container.decode(Account.self, forKey: .data))
        case .link:
            thing = .link(try container.decode(Message.self, forKey: .data))
        case .message:
            thing = .message(try container.decode(Message.self, forKey: .data))
        case .subreddit:
            thing = .subreddit(try container.decode(Subreddit.self, forKey: .data))
        case .award:
            thing = .award(try container.decode(Award.self, forKey: .data))
        case .more:
            thing = .more(try container.decode(More.self, forKey: .data))
        case .listing:
            thing = .listing(try container.decode(Listing.self, forKey: .data))
        }
    }
}
