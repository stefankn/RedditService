//
//  Comment.swift
//  
//
//  Created by Stefan Klein Nulent on 09/03/2021.
//

import Foundation

public struct Comment: Decodable, Identifiable {
    
    // MARK: - Types
    
    enum CodingKeys: String, CodingKey {
        case id
        case author
        case body
        case depth
        case replies
        case created
    }
    
    
    // MARK: - Private Properties
    
    private let created: Int
    
    
    
    // MARK: - Properties
    
    public let id: String
    public let author: String
    public let body: String
    public let depth: Int
    public var replies: [Comment] = []
    
    public var createdAt: Date {
        Date(timeIntervalSince1970: TimeInterval(created))
    }
    
    
    
    // MARK: - Construction
    
    public init(id: String, author: String, body: String, depth: Int, created: Int) {
        self.id = id
        self.author = author
        self.body = body
        self.depth = depth
        self.created = created
    }
    
    
    // MARK: Decodable Construction
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try container.decode(String.self, forKey: .id)
        author = try container.decode(String.self, forKey: .author)
        body = try container.decode(String.self, forKey: .body)
        depth = try container.decode(Int.self, forKey: .depth)
        created = try container.decode(Int.self, forKey: .created)
        
        let replies = try container.decode(DataResponse.self, forKey: .replies)
        
        if case let .listing(listing) = replies.thing {
            self.replies = listing.children.compactMap { thing -> Comment? in
                if case let .comment(comment) = thing {
                    return comment
                } else {
                    return nil
                }
            }
        }
    }
}
