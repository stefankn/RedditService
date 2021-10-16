//
//  Thing.swift
//  
//
//  Created by Stefan Klein Nulent on 12/03/2021.
//

import Foundation

enum Thing {
    case comment(Comment)
    case account(Account)
    case link(Message)
    case message(Message)
    case subreddit(Subreddit)
    case award(Award)
    case more(More)
    case listing(Listing)
}
