//
//  MoviesListPresenter.swift
//  CodeChallenge
//
//  Created by Oleh Kudinov on 01.10.18.
//

import Foundation

protocol iMoviesListEventHandler: class {
    
    func viewDidLoad()
    func didScrollToBottom()
    func searchBarSearchButtonClicked(text: String)
    func searchBarCancelButtonClicked()
    func didSelect(suggestion: String)
}

class MoviesListPresenter {
    
    var wireframe: MoviesListWireframe
    var interactor: MoviesListInteractor
    weak var view: MoviesListViewInterface?
    private var imageDataSource: ImageDataSourceInterface
    private var viewModel = MoviesListViewModel()
    private var moviesLoadTask: CancelableTask? { willSet { moviesLoadTask?.cancel() } }
    let numberOfQuerySuggestions = 10
    var querySuggestions: [String] { return interactor.recentsQueries(number: numberOfQuerySuggestions) }
    
    init(wireframe: MoviesListWireframe, interactor: MoviesListInteractor, imageDataSource: ImageDataSourceInterface) {
        self.wireframe = wireframe
        self.interactor = interactor
        self.imageDataSource = imageDataSource
        self.viewModel.suggestions = querySuggestions
    }
    
    private func updateView(loadingType: MoviesListViewModel.LoadingType) {
        guard !viewModel.query.isEmpty else { view?.viewModel = viewModel; return }
        
        viewModel.loadingType = loadingType
        view?.viewModel = viewModel
        moviesLoadTask = interactor.loadMovies(query: viewModel.query, page: viewModel.nextPage) { [weak self] result in
            guard let weakSelf = self else { return }
            if let moviesLoadTask = weakSelf.moviesLoadTask, !moviesLoadTask.isRunning {
                weakSelf.viewModel.loadingType = .none
                weakSelf.view?.viewModel = weakSelf.viewModel
            }

            switch result {
            case .success(let moviesPage):
                guard !moviesPage.movies.isEmpty else {
                    weakSelf.view?.showError(MoviesListViewModel.errorMovieNotFound)
                    return
                }
                weakSelf.interactor.saveRecentQuery(query: weakSelf.viewModel.query)
                weakSelf.viewModel.appendPage(moviesPage: moviesPage, imageDataSource: weakSelf.imageDataSource)
                weakSelf.viewModel.suggestions = weakSelf.querySuggestions
                weakSelf.view?.viewModel = weakSelf.viewModel
            case .failure(let error):
                weakSelf.handleError(error: error)
            }
        }
    }
    
    private func handleError(error: Error) {
        var errorMsg = MoviesListViewModel.errorFailedLoading
        if let error = error as? NetworkError {
            errorMsg = MoviesListViewModel.errorNoConnection
            if error == .cancelled { return }
        }
        view?.showError(errorMsg)
    }
}

extension MoviesListPresenter : iMoviesListEventHandler {

    func viewDidLoad() {
        updateView(loadingType: .none)
    }
    
    func didScrollToBottom() {
        guard viewModel.hasMorePages, !viewModel.isLoading else { return }
        updateView(loadingType: .nextPage)
    }
    
    func searchBarSearchButtonClicked(text: String) {
        guard !text.isEmpty else { return }
        viewModel = MoviesListViewModel(suggestions: querySuggestions, imageDataSource: imageDataSource)
        viewModel.query = text
        updateView(loadingType: .fullScreen)
    }
    
    func searchBarCancelButtonClicked() {
        moviesLoadTask?.cancel()
    }
    
    func didSelect(suggestion: String) {
        viewModel = MoviesListViewModel(suggestions: querySuggestions, imageDataSource: imageDataSource)
        viewModel.query = suggestion
        updateView(loadingType: .fullScreen)
    }
}
