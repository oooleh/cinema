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
    func didScrollToBottom()
}

class MoviesListPresenter {
        
    var wireframe: MoviesListWireframe
    var interactor: MoviesListInteractor
    var imageDataSource: ImageDataSourceInterface
    
    weak var view: MoviesListViewInterface?
    var viewModel = MoviesListViewModel()
    
    init(wireframe: MoviesListWireframe, interactor: MoviesListInteractor, imageDataSource: ImageDataSourceInterface) {
        self.wireframe = wireframe
        self.interactor = interactor
        self.imageDataSource = imageDataSource
    }
    
    private func updateView(loadingType: MoviesListViewModel.LoadingType) {

        self.viewModel.loadingType = loadingType
        view?.viewModel = viewModel
        
        self.interactor.loadMovies(page: viewModel.nextPage) { [weak self] result in
            guard let weakSelf = self else { return }
            weakSelf.viewModel.loadingType = .none
            weakSelf.view?.viewModel = weakSelf.viewModel
            switch result {
            case .success(let moviesPage):
                weakSelf.viewModel.appendPage(moviesPage: moviesPage, imageDataSource: weakSelf.imageDataSource)
                weakSelf.view?.viewModel = weakSelf.viewModel
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
        viewModel = MoviesListViewModel()
        updateView(loadingType: .pullToRefresh)
    }
    
    func didScrollToBottom() {
        guard viewModel.hasMorePages, !viewModel.isLoading else { return }
        updateView(loadingType: .nextPage)
    }
}
