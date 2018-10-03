//
//  MoviesListSuggestionViewModel.swift
//  CodeChallenge
//
//  Created by Oleh on 03.10.18.
//

import Foundation

extension MoviesListViewModel {
    
    struct Suggestion: Equatable {
        
        let text: String
    }
}

func ==(lhs: MoviesListViewModel.Suggestion, rhs: MoviesListViewModel.Suggestion) -> Bool {
    return (lhs.text == rhs.text)
}
