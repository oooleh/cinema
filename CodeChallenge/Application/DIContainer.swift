//
//  DIContainer.swift
//  CodeChallenge
//
//  Created by Oleh Kudinov on 01.10.18.
//

import Foundation
import  UIKit

class DIContainer {
    
    static let shared = DIContainer()
    
    // MARK: - Network
    let apiDataTransferService: DataTransferInterface
    let imageDataTransferService: DataTransferInterface
    
    // MARK: - Data Sources
    lazy var moviesDataSource: MoviesDataSourceInterface = {
        return MoviesDataSource(dataTransferService: apiDataTransferService,
                                moviesPersistentStorage: MoviesRecentQueriesStorage())
    }()
    
    lazy var imageDataSource: ImageDataSourceInterface = {
        return ImageDataSource(dataTransferService: imageDataTransferService)
    }()
    
    init() {
        let apiDataNetwork = NetworkService(session: URLSession.shared, config: ApiDataNetworkConfig())
        apiDataTransferService = DataTransferService(with: apiDataNetwork)
        let imageDataNetwork = NetworkService(session: URLSession.shared, config: ImageDataNetworkConfig())
        imageDataTransferService = DataTransferService(with: imageDataNetwork)
    }
}
