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
    
    func loadMovies(with completion: @escaping (Result<[Movie], Error>) -> Void) {
        moviesDataSource.moviesList() { result in
            DispatchQueue.main.async {
                completion(result)
            }
        }
    }
}
