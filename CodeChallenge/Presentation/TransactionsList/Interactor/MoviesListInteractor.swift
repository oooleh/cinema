//
//  MoviesListInteractor.swift
//  CodeChallenge
//
//  Created by Oleh Kudinov on 01.10.18.
//

import Foundation


class MoviesListInteractor {
    
    private let moviesDataSource: MoviesDataSourceInterface
    
    init(moviesDataSource: MoviesDataSourceInterface) {
        self.moviesDataSource = moviesDataSource
    }
    
    func loadMovies(query: String, page: Int, with completion: @escaping (Result<MoviesPage, Error>) -> Void) -> CancelableTask? {
        return moviesDataSource.moviesList(query: query, page: page) { result in
            DispatchQueue.main.async {
                completion(result)
            }
        }
    }
    
    func recentsQueries(number: Int) -> [MovieQuery] {
        return moviesDataSource.recentsQueries(number: number)
    }
    
    func saveRecentQuery(query: MovieQuery) {
        return moviesDataSource.saveRecentQuery(query: query)
    }
}
