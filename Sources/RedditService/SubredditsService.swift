//
//  SubredditsService.swift
//  
//
//  Created by Stefan Klein Nulent on 06/03/2021.
//

import Foundation
import Combine

final class SubredditsService: RedditService {
    
    // MARK: - Types
    
    public enum Sorting: String {
        case hot = "hot"
        case top = "top"
        case new = "new"
        case random = "random"
        case rising = "rising"
        case controversial = "controversial"
    }
    
    
 
    // MARK: - Functions
    
    func getSubscribedSubreddits(after: String? = nil, before: String? = nil, count: Int? = nil, limit: Int? = nil) -> AnyPublisher<SubredditsPager, Error> {
        get("/subreddits/mine/subscriber", parameters: createPagerParameters(after: after, before: before, count: count, limit: limit))
    }
    
    func getMessages(for subreddit: Subreddit, sorting: Sorting = .hot, after: String? = nil, before: String? = nil, count: Int? = nil, limit: Int? = nil) -> AnyPublisher<MessagesPager, Error> {
        get("/\(subreddit.displayNamePrefixed)/\(sorting.rawValue)", parameters: createPagerParameters(after: after, before: before, count: count, limit: limit))
    }
    
    func getHomeMessages(after: String? = nil, before: String? = nil, count: Int? = nil, limit: Int? = nil) -> AnyPublisher<MessagesPager, Error> {
        get("/", parameters: createPagerParameters(after: after, before: before, count: count, limit: limit))
    }
}
