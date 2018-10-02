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
    var nextPageLoadingSpinner: UIActivityIndicatorView?
    var viewModel: MoviesListViewModel! {
        didSet { reload(previousViewModel: oldValue, viewModel: viewModel) }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.estimatedRowHeight = MoviesListItemCell.height
        tableView.rowHeight = UITableViewAutomaticDimension
        refreshControl = UIRefreshControl()
        refreshControl?.attributedTitle = NSAttributedString(string: MoviesListViewModel.pullToRequestTitle)
        refreshControl?.addTarget(self, action: #selector(handleRefresh(_:)), for: UIControlEvents.valueChanged)
    }
    
    private func reload(previousViewModel: MoviesListViewModel?, viewModel: MoviesListViewModel) {
        guard previousViewModel?.items != viewModel.items ||
            previousViewModel?.loadingType != viewModel.loadingType else { return }
        setRefreshControl(isEnabled: true)
        setRefreshControl(isLoading: viewModel.loadingType == .pullToRefresh)
        setNextPage(isLoading: viewModel.loadingType == .nextPage)
        tableView.reloadData()
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
    
    private func setNextPage(isLoading: Bool) {
        if isLoading {
            nextPageLoadingSpinner?.removeFromSuperview()
            nextPageLoadingSpinner = UIActivityIndicatorView(activityIndicatorStyle: .gray)
            nextPageLoadingSpinner?.startAnimating()
            nextPageLoadingSpinner?.isHidden = false
            nextPageLoadingSpinner?.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: tableView.frame.width, height: 44)
            tableView.tableFooterView = nextPageLoadingSpinner
        }
        else {
            tableView.tableFooterView = nil
        }
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
        
        if indexPath.row == viewModel.numberOfRows(inSection: indexPath.section) - 1 {
            eventHandler?.didScrollToBottom()
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return viewModel.isEmpty ? tableView.frame.height : super.tableView(tableView, heightForRowAt: indexPath)
    }
}
