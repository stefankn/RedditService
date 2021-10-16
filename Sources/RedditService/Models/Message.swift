//
//  Message.swift
//  
//
//  Created by Stefan Klein Nulent on 07/03/2021.
//

import Foundation

public struct Message: Decodable, Identifiable, Equatable {
    
    // MARK: - Types
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case created
        case title
        case author = "author"
        case text = "selftext"
        case html = "selftext_html"
        case subreddit = "subreddit_name_prefixed"
        case thumbnailRawValue = "thumbnail"
    }
    
    
    
    // MARK: - Private Properties
    
    private let created: Int
    private let thumbnailRawValue: String
    
    
    
    // MARK: - Properties
    
    public let id: String
    public let name: String
    public let title: String
    public let author: String
    public let text: String
    public let html: String?
    public let subreddit: String
    
    public var thumbnail: URL? {
        URL(string: thumbnailRawValue)
    }
    
    public var createdAt: Date {
        Date(timeIntervalSince1970: TimeInterval(created))
    }
    
    
    
    // MARK: - Construction
    
    public init(id: String, name: String, title: String, author: String, text: String, html: String?, subreddit: String, thumbnail: String, created: Int) {
        self.id = id
        self.name = name
        self.title = title
        self.author = author
        self.text = text
        self.html = html
        self.subreddit = subreddit
        self.thumbnailRawValue = thumbnail
        self.created = created
    }
}
