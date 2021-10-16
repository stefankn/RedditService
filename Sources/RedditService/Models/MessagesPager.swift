//
//  MessagesPager.swift
//  
//
//  Created by Stefan Klein Nulent on 12/03/2021.
//

import Foundation

public struct MessagesPager: Decodable {
    
    // MARK: - Properties
    
    public let messages: [Message]
    public let before: String?
    public let after: String?
    
    
    
    // MARK: - Construction
    
    // MARK: Decodable Construction
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let data = try container.decode(DataResponse.self)
        
        if case let Thing.listing(listing) = data.thing {
            messages = listing.children.compactMap {
                switch $0 {
                case .message(let message), .link(let message):
                    return message
                default:
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
