//
//  MoviesRecentQueriesStorageInterface.swift
//  CodeChallenge
//
//  Created by Oleh on 03.10.18.
//

import Foundation

protocol MoviesRecentQueriesStorageInterface {
    func recentsQueries(number: Int) -> [MovieQuery]
    func saveRecentQuery(query: MovieQuery)
}
