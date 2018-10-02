//
//  Movie.swift
//  CodeChallenge
//
//  Created by Oleh Kudinov on 01.10.18.
//

import Foundation

typealias MovieId = Int

struct MoviesPage {
    let page: Int
    let totalPages: Int
    let movies: [Movie]
}

struct Movie {
    let id: MovieId
    let title: String
    let posterPath: String?
    let overview: String
    let releaseDate: Date?
}

extension Movie: Equatable {
    static func == (lhs: Movie, rhs: Movie) -> Bool {
        return (lhs.id == rhs.id)
    }
}

extension Movie: Hashable {
    var hashValue: Int {
        return id.hashValue
    }
}
