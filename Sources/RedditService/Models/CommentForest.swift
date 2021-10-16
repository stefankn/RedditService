//
//  CommentForest.swift
//  
//
//  Created by Stefan Klein Nulent on 19/03/2021.
//

import Foundation
import Combine

public final class CommentForest {
    
    // MARK: - Private Properties
    
    private let client: RedditClient
    private let message: Message
    private let limit: Int
    private let sorting: CommentSorting
    private var subscriptions: Set<AnyCancellable> = []
    
    private var initialMore: More?
    
    
    
    // MARK: - Properties
    
    @Published public var comments: [CommentElement] = []
    
    
    
    // MARK: - Construction
    
    init(client: RedditClient, message: Message, limit: Int, sorting: CommentSorting = .new) {
        self.client = client
        self.message = message
        self.limit = limit
        self.sorting = sorting
        
        fetch()
    }
    
    
    
    // MARK: - Functions
    
    public func more(at more: More) {
        let children: [String]
        if let initialMore = initialMore, initialMore == more, limit > 0 {
            children = Array(initialMore.children.prefix(limit))
            let remainingChildren = Array(initialMore.children.dropFirst(limit))
            self.initialMore = More(
                id: initialMore.id,
                link: initialMore.link,
                children: remainingChildren,
                count: remainingChildren.count,
                depth: initialMore.depth
            )
            
        } else {
            children = more.children
        }
        
        client.moreComments(for: message, children: children, sorting: sorting)
            .receive(on: DispatchQueue.main)
            .catch { error -> AnyPublisher<MoreCommentsResponse, Never> in
                print(error)
                return Empty().eraseToAnyPublisher()
            }
            .sink { response in
                if let index = self.comments.firstIndex(where: { commentElement in
                    if case let .more(m) = commentElement, more == m {
                        return true
                    } else {
                        return false
                    }
                }) {
                    self.comments.remove(at: index)
                    self.comments.insert(contentsOf: response.commentElements, at: index)
                }
                
                if let initialMore = self.initialMore, !initialMore.children.isEmpty, self.comments.last != .more(initialMore) {
                    self.comments.append(.more(initialMore))
                }
            }
            .store(in: &subscriptions)
    }
    
    
    
    // MARK: - Private Functions
    
    private func fetch() {
        client.getComments(for: message, sorting: sorting, limit: limit)
            .receive(on: DispatchQueue.main)
            .replaceError(with: [])
            .sink { commentElements in
                if case let .more(more) = commentElements.last {
                    self.initialMore = more
                }
                
                self.comments = commentElements
            }
            .store(in: &subscriptions)
    }
}
