//
//  MoviesListViewInterface.swift
//  CodeChallenge
//
//  Created by Oleh Kudinov on 01.10.18.
//

import Foundation

protocol MoviesListViewInterface: class {
    
    var viewModel: MoviesListViewModel { get set }
    var eventHandler: iMoviesListEventHandler? { get set }
    func showError(_ error: String)
}
