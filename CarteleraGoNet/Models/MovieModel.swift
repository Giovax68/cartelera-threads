//
//  MovieModel.swift
//  CarteleraGoNet
//
//  Created by Giovanny Bonifaz on 05/10/20.
//

import UIKit

class MovieModel {
	
	var id:Int!
	var poster:UIImage?
	var posterPath:String!
	var title:String!
	var overview:String!
	
	init() {}
	
	init(id:Int, posterPath:String, title:String, overview:String) {
		self.id = id
		self.posterPath = posterPath
		self.title = title
		self.overview = overview
	}
	
	func getURLImage() -> URL? {
		let urlString = "https://image.tmdb.org/t/p/original\(self.posterPath!)"
		return URL(string: urlString)
	}
}
