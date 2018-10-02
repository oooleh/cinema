//
//  moviesDataSource.swift
//  CodeChallenge
//
//  Created by Oleh Kudinov on 01.10.18.
//

import Foundation

class MoviesDataSource {
    
    private let dataTransferService: DataTransferInterface

    init(dataTransferService: DataTransferInterface) {
        self.dataTransferService = dataTransferService
    }
}

extension MoviesDataSource: MoviesDataSourceInterface {
    
    func moviesList(with result: @escaping (Result<[Movie], Error>) -> Void) -> CancelableTask? {
        let endpoint = APIEndpoints.movies.config
        
        return self.dataTransferService.request(with: endpoint) { (response: Result<MoviesList, Error>) in
            switch response {
            case .success(let moviesList):
                result(.success(moviesList.movies))
                return
            case .failure(let error):
                result(.failure(error))
                return
            }
        }
    }
}
