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
    @IBOutlet weak var tableViewContainer: UIView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var loadingView: UIActivityIndicatorView!
    @IBOutlet weak var emptyDataLabel: UILabel!
    
    private var tableViewController: MoviesListTableViewController?
    
    var viewModel: MoviesListViewModel = MoviesListViewModel() {
        didSet { updateViewModel(viewModel) }
    }
    var eventHandler: iMoviesListEventHandler? {
        didSet {
            tableViewController?.eventHandler = eventHandler
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        eventHandler?.viewDidLoad()
        title = MoviesListViewModel.title
        emptyDataLabel.text = MoviesListViewModel.emptyListTitle
        searchBar.delegate = self
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == String(describing: MoviesListTableViewController.self),
            let destinationVC = segue.destination as? MoviesListTableViewController {
            tableViewController = destinationVC
            tableViewController?.eventHandler = eventHandler
            tableViewController?.viewModel = viewModel
        }
    }
    
    private func updateViewModel(_ model: MoviesListViewModel) {
        setScreenMode(model: model)
        setupSearchBar(viewModel)
        tableViewController?.viewModel = viewModel
    }
    
    private func setScreenMode(model: MoviesListViewModel) {
        loadingView.isHidden = true
        emptyDataLabel.isHidden = true
        tableViewContainer.isHidden = true
        if model.loadingType == .fullScreen {
            loadingView.isHidden = false
        } else if model.isEmpty {
            emptyDataLabel.isHidden = false
        } else {
            tableViewContainer.isHidden = false
        }
    }
    
    private func setupSearchBar(_ model: MoviesListViewModel) {
        searchBar.text = model.query
        searchBar.placeholder = MoviesListViewModel.searchBarPlaceholder
    }
}

extension MoviesListView: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        tableViewController?.tableView.setContentOffset(CGPoint.zero, animated: false)
        eventHandler?.searchBarSearchButtonClicked(text: searchBar.text ?? "")
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
