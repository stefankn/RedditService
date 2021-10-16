//
//  Subreddit.swift
//  
//
//  Created by Stefan Klein Nulent on 06/03/2021.
//

import Foundation

public struct Subreddit: Decodable, Identifiable {
    
    // MARK: - Types
    
    enum ContainerCodingKeys: String, CodingKey {
        case data
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case displayName = "display_name"
        case displayNamePrefixed = "display_name_prefixed"
        case title
        case url
        case summary = "public_description"
        case description
        case isSubscribed = "user_is_subscriber"
    }
    
    
    
    // MARK: - Properties
    
    public let id: String
    public let displayName: String
    public let displayNamePrefixed: String
    public let title: String
    public let url: String
    public let summary: String
    public let description: String
    public let isSubscribed: Bool
    
    
    
    // MARK: - Construction
    
    public init(id: String, displayName: String, displayNamePrefixed: String, title: String, url: String, summary: String, description: String, isSubscribed: Bool) {
        self.id = id
        self.displayName = displayName
        self.displayNamePrefixed = displayNamePrefixed
        self.title = title
        self.url = url
        self.summary = summary
        self.description = description
        self.isSubscribed = isSubscribed
    }
}
