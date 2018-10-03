//
//  MoviesRecentQueriesStorage.swift
//  CodeChallenge
//
//  Created by Oleh on 03.10.18.
//

import Foundation

class MoviesRecentQueriesStorage: MoviesRecentQueriesStorageInterface {
    
    private let userDefaultsKey = "recentsMoviesQueries"
    
    func recentsQueries(number: Int) -> [String] {
        let queries = (UserDefaults.standard.value(forKey: userDefaultsKey) as? [String]) ?? []
        return queries.count < number ? queries : Array(queries[0..<number])
    }
    func saveRecentQuery(query: String) {
        var queries = (UserDefaults.standard.value(forKey: userDefaultsKey) as? [String]) ?? []
        queries = queries.filter { $0 != query }
        queries.insert(query, at: 0)
        UserDefaults.standard.set(queries, forKey: userDefaultsKey)
    }
}
