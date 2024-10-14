//
//  MovieDetailModel.swift
//  MovieSuggest
//
//  Created by Akshay Mamidwar    on 28/08/24.
//

import Foundation

class MovieDetailModel: Codable {

    let id: Int
    let name: String
    let duration: String
    let description: String
    let director: String
    let genres: [String]
    let actors: [String]

    enum CodingKeys: String, CodingKey {
        case id = "Id"
        case name = "Name"
        case duration = "Duration"
        case description = "Description"
        case director = "Director"
        case genres = "Genres"
        case actors = "Actors"
    }

    // Custom initialiser
    init(id: Int, name: String, duration: String, description: String, director: String, genres: [String], actors: [String]) {
        self.id = id
        self.name = name
        self.duration = duration
        self.description = description
        self.director = director
        self.genres = genres
        self.actors = actors
    }
}
