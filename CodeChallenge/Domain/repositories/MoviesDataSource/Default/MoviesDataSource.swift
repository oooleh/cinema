//
//  moviesDataSource.swift
//  CodeChallenge
//
//  Created by Oleh Kudinov on 01.10.18.
//

import Foundation


class MoviesDataSource {
    
    private let dataTransferService: DataTransferInterface
    private var moviesPersistentStorage: MoviesRecentQueriesStorageInterface
    
    init(dataTransferService: DataTransferInterface, moviesPersistentStorage: MoviesRecentQueriesStorageInterface) {
        self.dataTransferService = dataTransferService
        self.moviesPersistentStorage = moviesPersistentStorage
    }
}

extension MoviesDataSource: MoviesDataSourceInterface {

    func moviesList(query: String, page: Int, with result: @escaping (Result<MoviesPage, Error>) -> Void) -> CancelableTask? {
        let endpoint = APIEndpoints.movies(query: query, page: page).config
        
        return self.dataTransferService.request(with: endpoint) { (response: Result<MoviesPage, Error>) in
            switch response {
            case .success(let moviesPage):
                result(.success(moviesPage))
                return
            case .failure(let error):
                result(.failure(error))
                return
            }
        }
    }
    
    func recentsQueries(number: Int) -> [String] {
        return moviesPersistentStorage.recentsQueries(number: number)
    }
    
    func saveRecentQuery(query: String) {
        moviesPersistentStorage.saveRecentQuery(query: query)
    }
}
