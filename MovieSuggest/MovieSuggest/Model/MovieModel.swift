//
//  MovieModel.swift
//  MovieSuggest
//
//  Created by Akshay Mamidwar    on 28/08/24.
//

import Foundation

class MovieModel: Codable {

    let id: Int
    let rank: Int
    let name: String

    enum CodingKeys: String, CodingKey {
        case id = "Id"
        case rank = "Rank"
        case name = "Name"
    }
    
    // Custom initialiser for dummy data object creation
    init(id: Int, rank: Int, name: String) {
        self.id = id
        self.rank = rank
        self.name = name
    }
}
