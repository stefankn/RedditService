//
//  Kind.swift
//  
//
//  Created by Stefan Klein Nulent on 12/03/2021.
//

import Foundation

enum Kind: String, Decodable {
    case comment = "t1"
    case account = "t2"
    case link = "t3"
    case message = "t4"
    case subreddit = "t5"
    case award = "t6"
    case more = "more"
    case listing = "Listing"
}
