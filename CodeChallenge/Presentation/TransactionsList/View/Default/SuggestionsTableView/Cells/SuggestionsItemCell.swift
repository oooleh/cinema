//
//  SuggestionsItemCell.swift
//  CodeChallenge
//
//  Created by Oleh on 03.10.18.
//

import Foundation
import UIKit

class SuggestionsItemCell: UITableViewCell {
    
    static let reuseIdentifier = String(describing: SuggestionsItemCell.self)
    
    @IBOutlet weak var titleLabel: UILabel!
    
    func fill(with suggestion: MoviesListViewModel.Suggestion) {
        self.titleLabel.text = suggestion.text
    }
}
