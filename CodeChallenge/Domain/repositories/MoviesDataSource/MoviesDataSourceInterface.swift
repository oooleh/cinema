//
//  moviesDataSourceInterface.swift
//  CodeChallenge
//
//  Created by Oleh Kudinov on 01.10.18.
//

import Foundation

protocol MoviesDataSourceInterface {
    @discardableResult
    func moviesList(page: Int, with result: @escaping (Result<MoviesPage, Error>) -> Void) -> CancelableTask?
}
