//
//  More.swift
//  
//
//  Created by Stefan Klein Nulent on 12/03/2021.
//

import Foundation

public struct More: Decodable, Equatable {
    
    // MARK: - Types
    
    enum CodingKeys: String, CodingKey {
        case id
        case link = "parent_id"
        case children
        case count
        case depth
    }
    
    
    
    // MARK: - Properties
    
    public let id: String
    public let link: String
    private(set) var children: [String]
    public let count: Int
    public let depth: Int
    
    
    
    // MARK: - Construction
    
    public init(id: String, link: String, children: [String] = [], count: Int, depth: Int) {
        self.id = id
        self.link = link
        self.children = children
        self.count = count
        self.depth = depth
    }
}
