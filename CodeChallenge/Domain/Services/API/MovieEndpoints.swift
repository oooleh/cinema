//
//  MovieEndpoints.swift
//  CodeChallenge
//
//  Created by Oleh Kudinov on 01.10.18.
//

import Foundation

enum APIEndpoints {
    
    private static let moviePosterWidthSizes = [92, 185, 500, 780]
    
    case movies(page: Int)
    case moviePoster(path: String, width: Int)
    
    var config: Endpoint {
        switch self {
            
        case .movies(let page):
            return Endpoint(path: "3/search/movie/",
                            queryParameters: ["query": "batman",
                                              "page": "\(page)"])
        case .moviePoster(let path, let width):
            let availableWidth = APIEndpoints.moviePosterWidthSizes.sorted().first { width <= $0 } ?? APIEndpoints.moviePosterWidthSizes.last
            return Endpoint(path: "t/p/w\(availableWidth!)\(path)")
        }
    }
}
