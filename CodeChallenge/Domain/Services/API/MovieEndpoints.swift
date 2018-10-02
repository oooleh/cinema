//
//  MovieEndpoints.swift
//  CodeChallenge
//
//  Created by Oleh Kudinov on 01.10.18.
//

import Foundation

enum APIEndpoints {
    
    case movies
    case moviePoster(path: String)
    
    var config: Endpoint {
        switch self {
            
        case .movies:
            return Endpoint(path: "3/search/movie/",
                            queryParameters: ["query": "batman",
                                              "page": "1"])
        case .moviePoster(let path):
            return Endpoint(path: "t/p/w92/\(path)")
        }
    }
}
