//
//  moviesDataSourceInterface.swift
//  CodeChallenge
//
//  Created by Oleh Kudinov on 01.10.18.
//

import Foundation

protocol MoviesDataSourceInterface {
    @discardableResult
    func moviesList(query: String, page: Int, with result: @escaping (Result<MoviesPage, Error>) -> Void) -> CancelableTask?
    func recentsQueries(number: Int) -> [String]
    func saveRecentQuery(query: String)
}
