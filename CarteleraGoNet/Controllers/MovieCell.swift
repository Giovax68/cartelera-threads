//
//  MovieCell.swift
//  CarteleraGoNet
//
//  Created by M22 on 05/10/20.
//

import UIKit

class MovieCell: UITableViewCell {
	
	@IBOutlet weak var posterView: UIImageView!
	@IBOutlet weak var titleLabel: UILabel!
	@IBOutlet weak var overviewLabel: UILabel!
	
	
	func set(movie:MovieModel) {
		self.titleLabel.text = movie.title
		self.overviewLabel.text = movie.overview
		self.posterView?.contentMode = .scaleAspectFill
		
		if let url = movie.getURLImage(){
			ImageService.getImage(withURL: url) { (image) in
				movie.poster = image
				self.posterView?.image = image
			}
		}
	}
	
}

