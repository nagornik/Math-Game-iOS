//
//  OtherUser.swift
//  Math Game
//
//  Created by Anton Nagornyi on 02.09.2022.
//

import Foundation

struct OtherUser: Identifiable, Decodable {
    var id: String
    var name: String
    var topScores: [String : Int?]
    var photo: String?
}
