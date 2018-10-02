//
//  MoviesListWireframe.swift
//  CodeChallenge
//
//  Created by Oleh Kudinov on 01.10.18.
//

import Foundation
import  UIKit

protocol MoviesListDependencies {
    var imageDataSource: ImageDataSourceInterface { get }
    var moviesDataSource: MoviesDataSourceInterface { get }
}

extension DIContainer: MoviesListDependencies {}

class MoviesListWireframe {

    private weak var presenter: MoviesListPresenter?
    
    class func assemble(dependencies: MoviesListDependencies, forView view: MoviesListViewInterface) {
        
        let wireframe = MoviesListWireframe()
        let interactor = MoviesListInteractor(moviesDataSource: dependencies.moviesDataSource)
        
        let presenter = MoviesListPresenter(wireframe: wireframe, interactor: interactor, imageDataSource: dependencies.imageDataSource)
        presenter.view = view
        view.eventHandler = presenter
        wireframe.presenter = presenter
    }
}

