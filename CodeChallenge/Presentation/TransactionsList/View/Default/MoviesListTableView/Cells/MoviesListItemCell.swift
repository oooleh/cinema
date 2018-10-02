//
//  MoviesListItemCell.swift
//  CodeChallenge
//
//  Created by Oleh Kudinov on 01.10.18.
//

import Foundation
import UIKit

class MoviesListItemCell: UITableViewCell {
    
    static let reuseIdentifier = String(describing: MoviesListItemCell.self)
    static let height = CGFloat(130)
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    @IBOutlet weak var posterImageView: UIImageView!
    
    private var imageLoadTask: CancelableTask? { willSet { imageLoadTask?.cancel() } }
    private var item: MoviesListViewModel.Item?
    
    
    func fill(with item: MoviesListViewModel.Item) {
        self.item = item
        
        titleLabel.text = item.title
        dateLabel.text = "\(MoviesListViewModel.releaseDateTitle): \(item.releaseDate)"
        overviewLabel.text = item.overview
        
        imageLoadTask = item.loadImage { [weak self] image in
            guard let weakSelf = self else { return }
            guard weakSelf.item == item else {
                weakSelf.imageView?.image = nil; return
            }
            weakSelf.posterImageView.image = image
        }
    }
}
