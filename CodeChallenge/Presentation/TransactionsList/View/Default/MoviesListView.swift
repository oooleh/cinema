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
    @IBOutlet weak var loadingView: UIActivityIndicatorView!
    
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
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == String(describing: MoviesListTableViewController.self),
            let destinationVC = segue.destination as? MoviesListTableViewController {
            tableViewController = destinationVC
            tableViewController?.eventHandler = eventHandler
            tableViewController?.viewModel = viewModel
            tableViewController?.reload()
        }
    }
    
    private func setFullScreen(isLoading: Bool) {
        contentView.isHidden = isLoading
        loadingView.isHidden = !isLoading
    }
    
    private func updateViewModel(_ model: MoviesListViewModel) {
        setFullScreen(isLoading: model.loadingType == .fullScreen)
        tableViewController?.viewModel = viewModel
        tableViewController?.reload()
    }
}

extension MoviesListView: MoviesListViewInterface {
    
    func showError(_ error: String) {
        showAlert(title: MoviesListViewModel.errorTitle, message: error)
    }
}
