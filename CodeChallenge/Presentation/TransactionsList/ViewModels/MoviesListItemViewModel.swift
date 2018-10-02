//
//  MoviesListItem.swift
//  CodeChallenge
//
//  Created by Oleh Kudinov on 01.10.18.
//

import Foundation
import UIKit

extension MoviesListViewModel {
    
    struct Item: Equatable {
        
        let id: Int
        let title: String
        let posterPath: String?
        let overview: String
        let releaseDate: String
        let imageDataSource: ImageDataSourceInterface?
        
        init(movie: Movie, imageDataSource: ImageDataSourceInterface? = nil) {
            
            self.id = movie.id
            self.title = movie.title
            self.posterPath = movie.posterPath
            self.overview = movie.overview
            let formatter = DateFormatter()
            formatter.dateStyle = .medium
            self.releaseDate = movie.releaseDate != nil ? formatter.string(from: movie.releaseDate!) : MoviesListViewModel.releaseDateToBeAnnounced
            self.imageDataSource = imageDataSource
        }
        
        func loadImage(width: Int, completion: @escaping ((_ image: UIImage?) -> Void)) -> CancelableTask? {

            guard let imageDataSource = imageDataSource, let posterPath = posterPath else { completion(nil); return nil }
            return imageDataSource.image(with: APIEndpoints.moviePoster(path: posterPath, width: width).config) { result in
                    switch result {
                    case .success(let image):
                        completion(image)
                    case .failure(let error):
                        if let networkError = error as? NetworkError, networkError.isNotFoundError {
                            completion(UIImage(named: "image_not_found"))
                        } else {
                            completion(nil)
                        }
                    }
            }
        }
    }
}

func ==(lhs: MoviesListViewModel.Item, rhs: MoviesListViewModel.Item) -> Bool {
    return (lhs.id == rhs.id)
}
