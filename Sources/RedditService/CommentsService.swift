//
//  CommentsService.swift
//  
//
//  Created by Stefan Klein Nulent on 09/03/2021.
//

import Foundation
import Combine

final class CommentsService: RedditService {
    
    // MARK: - Functions
    
    func getComments(for message: Message, sorting: CommentSorting = .new, limit: Int = 10) -> AnyPublisher<[CommentElement], Error> {
        let response: AnyPublisher<CommentsResponse, Error> = get("/\(message.subreddit)/comments/\(message.id)", parameters: [
            //(name: "limit", value: limit),
            (name: "sort", value: sorting.rawValue)
        ]).eraseToAnyPublisher()
        
        return response.map{ $0.commentElements }.eraseToAnyPublisher()
    }
    
    func moreComments(for message: Message, children: [String], sorting: CommentSorting = .new) -> AnyPublisher<MoreCommentsResponse, Error> {
        get("/api/morechildren", parameters: [
            (name: "api_type", "json"),
            (name: "link_id", value: message.name),
            (name: "children", value: children.joined(separator: ",")),
            (name: "sort", value: sorting.rawValue)
        ])
    }
}
