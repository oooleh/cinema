//
//  moviesDataSourceInterface.swift
//  CodeChallenge
//
//  Created by Oleh Kudinov on 01.10.18.
//

import Foundation

protocol MoviesDataSourceInterface {
    @discardableResult
    func moviesList(with result: @escaping (Result<[Movie], Error>) -> Void) -> CancelableTask?
}
