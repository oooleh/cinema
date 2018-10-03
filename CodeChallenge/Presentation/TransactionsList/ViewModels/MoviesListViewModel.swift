//
//  MoviesListViewModel.swift
//  CodeChallenge
//
//  Created by Oleh Kudinov on 01.10.18.
//

import Foundation
import UIKit

private extension Sequence where Element == Movie {
    func mapToItems(imageDataSource: ImageDataSourceInterface?) -> [MoviesListViewModel.Item] {
        return map{ MoviesListViewModel.Item(movie: $0, imageDataSource: imageDataSource) }
    }
}

struct MoviesListViewModel {
    
    enum LoadingType {
        case none
        case fullScreen
        case nextPage
    }
    
    private(set) var items: [Item] = []
    private(set) var suggestions: [Suggestion]
    private(set) var currentPage: Int = 0
    private(set) var totalPageCount: Int = 1
    var isEmpty: Bool { return items.isEmpty }
    var isLoading: Bool { return loadingType != .none }
    var loadingType: LoadingType = .none
    var query: String = ""
    

    var hasMorePages: Bool {
        return currentPage < totalPageCount
    }
    
    var nextPage: Int {
        guard hasMorePages else { return currentPage }
        return currentPage + 1
    }
    
    init(moviesPage: MoviesPage? = nil, moviesQueries: [MovieQuery] = [], imageDataSource: ImageDataSourceInterface? = nil) {
        self.suggestions = moviesQueries.map { Suggestion(text: $0.query) }
        guard let moviesPage = moviesPage else { return }
        appendPage(moviesPage: moviesPage, imageDataSource: imageDataSource)
    }
    
    var numberOfSections: Int {
        return 1
    }
    
    func numberOfRows(inSection section: Int) -> Int {
        guard section < numberOfSections else { return 0 }
        return items.count
    }
    
    func item(at indexPath: IndexPath) -> Item? {
        return items[indexPath.row]
    }
    
    mutating func appendPage(moviesPage: MoviesPage, imageDataSource: ImageDataSourceInterface? = nil) {
        self.currentPage = moviesPage.page
        self.totalPageCount = moviesPage.totalPages
        self.items = items + moviesPage.movies.mapToItems(imageDataSource: imageDataSource)
    }
    
    mutating func updateSuggestions(moviesQueries: [MovieQuery]) {
        self.suggestions = moviesQueries.map { Suggestion(text: $0.query) }
    }
}

extension MoviesListViewModel {
    static let title = NSLocalizedString("Movies", comment: "")
    static let searchBarPlaceholder = NSLocalizedString("Search Movies", comment: "")
    static let emptyListTitle = NSLocalizedString("List is empty.", comment: "")
    static let errorTitle = NSLocalizedString("Error", comment: "")
    static let errorNoConnection = NSLocalizedString("No internet connection", comment: "")
    static let errorMovieNotFound = NSLocalizedString("The film does not exist", comment: "")
    static let errorFailedLoading = NSLocalizedString("Failed loading movies", comment: "")
    static let releaseDateTitle = NSLocalizedString("Release Date", comment: "")
    static let releaseDateToBeAnnounced = NSLocalizedString("To be announced", comment: "")
}
