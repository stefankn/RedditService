//
//  CommentElement.swift
//  
//
//  Created by Stefan Klein Nulent on 19/03/2021.
//

import Foundation

public enum CommentElement: Identifiable, Equatable {
    case comment(Comment)
    case more(More)
    
    
    // MARK: - Properties
    
    // MARK: Identifiable Properties
    
    public var id: String {
        switch self {
        case .comment(let comment):
            return comment.id
        case .more(let more):
            return more.children.joined()
        }
    }
    
    
    
    // MARK: - Functions
    
    // MARK: Equatable Functions
    
    public static func == (lhs: CommentElement, rhs: CommentElement) -> Bool {
        lhs.id == rhs.id
    }
}
