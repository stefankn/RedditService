//
//  Listing.swift
//  
//
//  Created by Stefan Klein Nulent on 12/03/2021.
//

import Foundation

struct Listing: Decodable {
    
    // MARK: - Types
    
    enum CodingKeys: String, CodingKey {
        case children
        case before
        case after
    }
    
    
    
    // MARK: - Properties
    
    let children: [Thing]
    let before: String?
    let after: String?
    
    
    
    // MARK: - Construction
    
    // MARK: Decodable Construction
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let children = try container.decode([DataResponse].self, forKey: .children)
        
        self.children = children.map{ $0.thing }
        before = try container.decodeIfPresent(String.self, forKey: .before)
        after = try container.decodeIfPresent(String.self, forKey: .after)
    }
}
