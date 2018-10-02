//
//  Movie+Decodable.swift
//  CodeChallenge
//
//  Created by Oleh on 22.09.18.
//

import Foundation

struct MoviesList {
    let page: Int
    let totalPages: Int
    let movies: [Movie]
}

extension MoviesList : Decodable {
    
    private enum CodingKeys: String, CodingKey {
        case page
        case totalPages = "total_pages"
        case movies = "results"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.page = try container.decode(Int.self, forKey: .page)
        self.totalPages = try container.decode(Int.self, forKey: .totalPages)
        self.movies = try container.decode([Movie].self, forKey: .movies)
    }
}

extension Movie: Decodable {
    private enum CodingKeys: String, CodingKey {
        
        case id
        case title
        case posterPath = "poster_path"
        case overview
        case releaseDate = "release_date"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)
        self.title = try container.decode(String.self, forKey: .title)
        self.posterPath = try container.decode(String.self, forKey: .posterPath)
        self.overview = try container.decode(String.self, forKey: .overview)
        let releaseDateString = try container.decode(String.self, forKey: .releaseDate)
        if let mappedDate = DateFormatter.yyyyMMdd.date(from: releaseDateString) {
            releaseDate = mappedDate
        } else {
            throw DecodingError.dataCorruptedError(forKey: .releaseDate,
                                                   in: container,
                                                   debugDescription: "Date string does not match format")
        }
    }
}



fileprivate extension DateFormatter {
    static let yyyyMMdd: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter
    }()
}