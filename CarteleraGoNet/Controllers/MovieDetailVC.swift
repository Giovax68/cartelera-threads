//
//  MovieDetailVC.swift
//  CarteleraGoNet
//
//  Created by M22 on 05/10/20.
//

import UIKit

class MovieDetailVC: UIViewController {
	
	@IBOutlet weak var movieTitle: UILabel!
	@IBOutlet weak var content: UILabel!
	@IBOutlet weak var image: UIImageView!
	
	@IBOutlet var IBConstraints: [NSLayoutConstraint]!
	var landscapeConstraints: [NSLayoutConstraint] = []
	
	var movie:MovieModel?
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		self.setValues()
	}

	
	override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
		
		self.orientationChanged()
	}
	
	func setValues(){
		if let m = movie{
			movieTitle.text = m.title
			content.text = m.overview
			image.image = m.poster
		}
	}
	
	func orientationChanged() {
		let deviceOrientation = UIDevice.current.orientation
		
		switch deviceOrientation {
			case .portrait:
				print("Portrait")
				self.applyPortraitConstraints()
				
			case .landscapeLeft, .landscapeRight:
				print("landscape")
				self.applyLandscapeConstraints()
			default:
				break
		}
	}
	
	func applyLandscapeConstraints() {
		NSLayoutConstraint.deactivate(IBConstraints)
		self.setLandscapeConstraints()
	}
	
	func applyPortraitConstraints() {
		NSLayoutConstraint.deactivate(landscapeConstraints)
		view.addConstraints(IBConstraints)
	}
	
	func setLandscapeConstraints() {
		movieTitle.translatesAutoresizingMaskIntoConstraints = false
		content.translatesAutoresizingMaskIntoConstraints = false
		image.translatesAutoresizingMaskIntoConstraints = false
		
		let titlePinLeadingToImage = NSLayoutConstraint(item: movieTitle!, attribute: .leading, relatedBy: .equal, toItem: image, attribute: .trailing, multiplier: 1.0, constant: 25)
		self.view.addConstraint(titlePinLeadingToImage)
		landscapeConstraints.append(titlePinLeadingToImage)
		
		let contentPinToTitle = NSLayoutConstraint(item: content!, attribute: .top, relatedBy: .equal, toItem: movieTitle, attribute: .bottom, multiplier: 1.0, constant: 25.0)
		self.view.addConstraint(contentPinToTitle)
		landscapeConstraints.append(contentPinToTitle)
		
		let imageCenterVertical = NSLayoutConstraint(item: image!, attribute: .centerY, relatedBy: .equal, toItem: self.view, attribute: .centerYWithinMargins, multiplier: 1.0, constant: 0.0)
		let imagePinToLeading = NSLayoutConstraint(item: image!, attribute: .leading, relatedBy: .equal, toItem: self.view, attribute: .leading, multiplier: 1.0, constant: 25)
		self.view.addConstraint(imageCenterVertical)
		self.view.addConstraint(imagePinToLeading)
		landscapeConstraints.append(imageCenterVertical)
		landscapeConstraints.append(imagePinToLeading)
		
	}
	
	
}
