//
//  File.swift
//  CodeChallenge
//
//  Created by Oleh on 23.09.18.
//

import Foundation
import UIKit

class MoviesListEmptyDataCell: UITableViewCell {
    
    static let reuseIdentifier = String(describing: MoviesListEmptyDataCell.self)
    
    @IBOutlet weak var descriptionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        descriptionLabel.text = MoviesListViewModel.emptyListTitle
    }
}

