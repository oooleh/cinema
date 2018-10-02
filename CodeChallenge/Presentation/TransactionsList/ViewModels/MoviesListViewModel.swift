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

private extension Sequence where Element == Movie {
    var sortedMovies: [Movie] {
        return sorted(by: { $0.releaseDate > $1.releaseDate })
    }
}

struct MoviesListViewModel {

    enum LoadingType {
        case none
        case fullScreen
        case pullToRefresh
    }
    
    private(set) var items: [Item]
    var isEmpty: Bool { return items.isEmpty }
    var isLoading: Bool { return loadingType != .none }
    var loadingType: LoadingType = .none

    init(movies: [Movie]? = nil, imageDataSource: ImageDataSourceInterface? = nil) {
        self.items = movies?.sortedMovies.mapToItems(imageDataSource: imageDataSource) ?? []
    }

    var numberOfSections: Int {
        return 1
    }
    
    func numberOfRows(inSection section: Int) -> Int {
        guard section < numberOfSections else { return 0 }
        return !isEmpty ? items.count: 1
    }
    
    func item(at indexPath: IndexPath) -> Item? {
        return items[indexPath.row]
    }
}

extension MoviesListViewModel {
    static let title = NSLocalizedString("Movies", comment: "")
    static let emptyListTitle = NSLocalizedString("You list is empty.\nPlease Pull to refresh", comment: "")
    static let errorTitle = NSLocalizedString("Error", comment: "")
    static let errorNoConnection = NSLocalizedString("No internet connection", comment: "")
    static let errorFailedReloading = NSLocalizedString("Failed reloading movies", comment: "")
    static let pullToRequestTitle = NSLocalizedString("Pull to refresh", comment: "")
    static let releaseDateTitle = NSLocalizedString("Release Date", comment: "")
}
