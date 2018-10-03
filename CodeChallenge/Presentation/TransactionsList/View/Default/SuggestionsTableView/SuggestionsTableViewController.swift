//
//  SuggestionsTableViewController.swift
//  CodeChallenge
//
//  Created by Oleh on 03.10.18.
//

import Foundation
import UIKit

class SuggestionsTableViewController: UITableViewController {
    
    weak var eventHandler: iMoviesListEventHandler?
    var viewModel: MoviesListViewModel! {
        didSet { reload(previousViewModel: oldValue, viewModel: viewModel) }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
        tableView.backgroundColor = .clear
    }
    
    private func reload(previousViewModel: MoviesListViewModel?, viewModel: MoviesListViewModel) {
        guard previousViewModel?.suggestions != viewModel.suggestions else { return }
        tableView.reloadData()
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate
extension SuggestionsTableViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.suggestions.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: SuggestionsItemCell.reuseIdentifier, for: indexPath) as! SuggestionsItemCell
        cell.fill(with: viewModel.suggestions[indexPath.row])
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        eventHandler?.didSelect(suggestion: viewModel.suggestions[indexPath.row])
    }
}
