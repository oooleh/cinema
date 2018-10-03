//
//  MoviesListView.swift
//  CodeChallenge
//
//  Created by Oleh Kudinov on 01.10.18.
//

import Foundation
import UIKit

class MoviesListView: UIViewController, Alertable {
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var moviesListContainer: UIView!
    @IBOutlet weak var suggestionsListContainer: UIView!
    @IBOutlet weak var searchBarContainer: UIView!
    @IBOutlet weak var loadingView: UIActivityIndicatorView!
    @IBOutlet weak var emptyDataLabel: UILabel!
    
    private var moviesTableViewController: MoviesListTableViewController?
    private var suggestionsTableViewController: SuggestionsTableViewController!
    
    private var searchController = UISearchController(searchResultsController: nil)
    
    var viewModel: MoviesListViewModel = MoviesListViewModel() {
        didSet { updateViewModel(viewModel) }
    }
    var eventHandler: iMoviesListEventHandler? 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        eventHandler?.viewDidLoad()
        title = MoviesListViewModel.title
        emptyDataLabel.text = MoviesListViewModel.emptyListTitle
        setupSearchController()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == String(describing: MoviesListTableViewController.self),
            let destinationVC = segue.destination as? MoviesListTableViewController {
            moviesTableViewController = destinationVC
            moviesTableViewController?.eventHandler = eventHandler
            moviesTableViewController?.viewModel = viewModel
        } else if segue.identifier == String(describing: SuggestionsTableViewController.self),
            let destinationVC = segue.destination as? SuggestionsTableViewController {
            suggestionsTableViewController = destinationVC
            suggestionsTableViewController?.eventHandler = eventHandler
            suggestionsTableViewController?.viewModel = viewModel
        }
    }
    
    private func updateViewModel(_ model: MoviesListViewModel) {
        setScreenMode(model: model)
        moviesTableViewController?.viewModel = viewModel
        suggestionsTableViewController?.viewModel = viewModel
        updateSearchController(viewModel)
        updateSuggestionsListVisibility(viewModel)
    }
    
    private func setScreenMode(model: MoviesListViewModel) {
        loadingView.isHidden = true
        emptyDataLabel.isHidden = true
        moviesListContainer.isHidden = true
        suggestionsListContainer.isHidden = true
        if model.loadingType == .fullScreen {
            loadingView.isHidden = false
            updateSuggestionsListVisibility(viewModel)
        } else if model.isEmpty {
            emptyDataLabel.isHidden = false
            updateSuggestionsListVisibility(viewModel)
        } else {
            moviesListContainer.isHidden = false
            updateSuggestionsListVisibility(viewModel)
        }
    }
    
    private func updateSearchController(_ model: MoviesListViewModel) {
        searchController.isActive = false
        searchController.searchBar.text = model.query
    }
    
    private func setupSearchController() {
        searchController.delegate = self
        searchController.searchBar.delegate = self
        searchController.searchBar.placeholder = MoviesListViewModel.searchBarPlaceholder
        if #available(iOS 9.1, *) {
            searchController.obscuresBackgroundDuringPresentation = false
        } else {
            searchController.dimsBackgroundDuringPresentation = true
        }
        searchController.searchBar.translatesAutoresizingMaskIntoConstraints = true
        searchController.searchBar.barStyle = .black
        searchController.searchBar.frame = searchBarContainer.bounds
        searchController.searchBar.autoresizingMask = [.flexibleWidth]
        searchBarContainer.addSubview(searchController.searchBar)
        definesPresentationContext = true
        updateSuggestionsListVisibility(viewModel)
    }
    
    private func updateSuggestionsListVisibility(_ model: MoviesListViewModel) {
        suggestionsListContainer.isHidden = !searchController.searchBar.isFirstResponder
    }
}

extension MoviesListView: UISearchBarDelegate {

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchText = searchBar.text, !searchText.isEmpty else { return }
        searchController.isActive = false
        moviesTableViewController?.tableView.setContentOffset(CGPoint.zero, animated: false)
        eventHandler?.searchBarSearchButtonClicked(text: searchText)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        eventHandler?.searchBarCancelButtonClicked()
    }
}

extension MoviesListView: MoviesListViewInterface {
    
    func showError(_ error: String) {
        showAlert(title: MoviesListViewModel.errorTitle, message: error)
    }
}

extension MoviesListView: UISearchControllerDelegate {
    public func willPresentSearchController(_ searchController: UISearchController) {
        updateSuggestionsListVisibility(viewModel)
    }
    
    public func willDismissSearchController(_ searchController: UISearchController) {
        updateSuggestionsListVisibility(viewModel)
    }

    public func didDismissSearchController(_ searchController: UISearchController) {
        updateSuggestionsListVisibility(viewModel)
    }
}
