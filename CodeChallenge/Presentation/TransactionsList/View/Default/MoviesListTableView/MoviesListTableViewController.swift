//
//  MoviesListTableViewController.swift
//  CodeChallenge
//
//  Created by Oleh Kudinov on 01.10.18.
//

import Foundation
import UIKit

class MoviesListTableViewController: UITableViewController {
    
    weak var eventHandler: iMoviesListEventHandler?
    var viewModel: MoviesListViewModel! {
        didSet { reload() }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        refreshControl = UIRefreshControl()
        refreshControl?.attributedTitle = NSAttributedString(string: MoviesListViewModel.pullToRequestTitle)
        refreshControl?.addTarget(self, action: #selector(handleRefresh(_:)), for: UIControlEvents.valueChanged)
    }
    
    func reload() {
        tableView.reloadData()
        tableView.estimatedRowHeight = MoviesListItemCell.height
        tableView.rowHeight = UITableViewAutomaticDimension
        setRefreshControl(isEnabled: true)
        setRefreshControl(isLoading: viewModel.loadingType == .pullToRefresh)
    }
    
    private func setRefreshControl(isEnabled: Bool) {
        guard let refreshControl = refreshControl else { return }
        if isEnabled {
            tableView.addSubview(refreshControl)
        } else {
            refreshControl.removeFromSuperview()
        }
    }
    
    private func setRefreshControl(isLoading: Bool) {
        if isLoading {
            refreshControl?.beginRefreshing()
        } else {
            endRefreshing()
        }
    }
    
    private func endRefreshing() {
        guard let refreshControl = refreshControl else { return }
        if refreshControl.isRefreshing {
            tableView.setContentOffset(.zero, animated: true)
            refreshControl.endRefreshing()
        }
    }
    
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        eventHandler?.didPullDownToRefresh()
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate
extension MoviesListTableViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.numberOfSections
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows(inSection: section)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard !viewModel.isEmpty else {
            return tableView.dequeueReusableCell(withIdentifier: MoviesListEmptyDataCell.reuseIdentifier, for: indexPath) as! MoviesListEmptyDataCell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: MoviesListItemCell.reuseIdentifier, for: indexPath) as! MoviesListItemCell
        
        if let item = viewModel.item(at: indexPath) {
            cell.fill(with: item)
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return viewModel.isEmpty ? tableView.frame.height : super.tableView(tableView, heightForRowAt: indexPath)
    }
}
