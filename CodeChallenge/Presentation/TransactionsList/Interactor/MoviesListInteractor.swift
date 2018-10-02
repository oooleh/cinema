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
    
    func loadMovies(page: Int, with completion: @escaping (Result<MoviesPage, Error>) -> Void) {
        moviesDataSource.moviesList(page: page) { result in
            DispatchQueue.main.async {
                completion(result)
            }
        }
    }
}
