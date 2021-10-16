//
//  MoreCommentsResponse.swift
//  
//
//  Created by Stefan Klein Nulent on 19/03/2021.
//

import Foundation

struct MoreCommentsResponse: Decodable {
    
    // MARK: - Types
    
    private enum CodingKeys: String, CodingKey {
        case json
    }
    
    private enum WrapperCodingKeys: String, CodingKey {
        case data
    }
    
    private enum DataCodingKeys: String, CodingKey {
        case things
    }
    
    
    // MARK: - Properties
    
    let commentElements: [CommentElement]
    
    
    
    // MARK: - Construction
    
    // MARK: Decodable Construction
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let wrapper = try container.nestedContainer(keyedBy: WrapperCodingKeys.self, forKey: .json)
        let dataContainer = try wrapper.nestedContainer(keyedBy: DataCodingKeys.self, forKey: .data)
        
        let things = try dataContainer.decode([DataResponse].self, forKey: .things)
        
        commentElements = things.compactMap {
            switch $0.thing {
            case .comment(let comment):
                return .comment(comment)
            case .more(let more):
                return .more(more)
            default:
                return nil
            }
        }
    }
}
