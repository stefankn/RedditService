//
//  Identity.swift
//  
//
//  Created by Stefan Klein Nulent on 06/03/2021.
//

import Foundation

public struct Identity: Decodable {
    
    // MARK: - Types
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case avatarURL = "snoovatar_img"
    }
    
    
    
    // MARK: - Properties
    
    public let id: String
    public let name: String
    public let avatarURL: String?
}
