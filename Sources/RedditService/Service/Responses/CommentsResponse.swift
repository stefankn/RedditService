//
//  CommentsResponse.swift
//  
//
//  Created by Stefan Klein Nulent on 12/03/2021.
//

import Foundation

public struct CommentsResponse: Decodable {
    
    // MARK: - Properties
    
    private(set) var commentElements: [CommentElement] = []
    
    
    
    // MARK: - Construction
    
    // MARK: Decodable Construction
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let data = try container.decode([DataResponse].self)
        
        if let data = data.last, case let Thing.listing(listing) = data.thing {
            commentElements = listing.children.compactMap {
                switch $0 {
                case .comment(let comment):
                    return addComment(comment)
                case .more(let more):
                    return .more(more)
                default:
                    return nil
                }
            }
        } else {
            throw DecodingError.dataCorruptedError(in: container, debugDescription: "")
        }
    }
    
    
    // MARK: - Private Functions
    
    private func addComment(_ comment: Comment, to parentComment: Comment? = nil) -> CommentElement {
        
        
        return .comment(comment)
    }
}
