//
//  MoviesListPresenter.swift
//  CodeChallenge
//
//  Created by Oleh Kudinov on 01.10.18.
//

import Foundation

protocol iMoviesListEventHandler: class {
    
    func viewDidLoad()
    func didPullDownToRefresh()
}

class MoviesListPresenter {
        
    var wireframe: MoviesListWireframe
    var interactor: MoviesListInteractor
    var imageDataSource: ImageDataSourceInterface
    
    weak var view: MoviesListViewInterface?
    
    init(wireframe: MoviesListWireframe, interactor: MoviesListInteractor, imageDataSource: ImageDataSourceInterface) {
        self.wireframe = wireframe
        self.interactor = interactor
        self.imageDataSource = imageDataSource
    }
    
    private func updateView(loadingType: MoviesListViewModel.LoadingType) {
        
        guard let view = view else { return }
        
        var oldViewModel = view.viewModel
        oldViewModel.loadingType = loadingType
        view.viewModel = oldViewModel
        
        self.interactor.loadMovies() { [weak self] result in
            guard let weakSelf = self else { return }
            oldViewModel.loadingType = .none
            weakSelf.view?.viewModel = oldViewModel
            switch result {
            case .success(let movies):
                weakSelf.view?.viewModel = MoviesListViewModel(movies: movies, imageDataSource: weakSelf.imageDataSource)
                return
            case .failure(let error):
                let userErrorMessage = (error is NetworkError) ? MoviesListViewModel.errorNoConnection : MoviesListViewModel.errorFailedReloading
                weakSelf.view?.showError(userErrorMessage)
                return
            }
        }
    }
}

extension MoviesListPresenter : iMoviesListEventHandler {

    func viewDidLoad() {
        updateView(loadingType: .fullScreen)
    }
    
    func didPullDownToRefresh() {
        updateView(loadingType: .pullToRefresh)
    }
}
