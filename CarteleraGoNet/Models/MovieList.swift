//
//  MovieList.swift
//  CarteleraGoNet
//
//  Created by Giovanny Bonifaz on 05/10/20.
//

import UIKit
import Alamofire

class MovieList {
	
	let APIKEY:String = "90a483b01253df24027872c7c4498df5"
	var movies:[MovieModel]?
	
	func getData(success:@escaping () -> Void, failure:@escaping () -> Void) {
		
		let url:String = "https://api.themoviedb.org/3/movie/popular?api_key=\(APIKEY)&language=es-MX"
		
		AF.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
			switch response.result {
				case .success(let value):
					if let value = value as? Parameters, let movies = value["results"] as? [Parameters] {
						self.processData(results: movies)
						success()
					}
					failure()
				case .failure(let error):
					print("\(error.localizedDescription) at \(#file) \(#function) \(#line)")
					failure()
			}
		}
	}
	
	func processData(results:[Parameters]){
		self.movies = []
		for data in results {
			
			guard let id = data["id"] as? Int else { continue }
			
			guard let title = data["title"] as? String else { continue }
			
			guard let poster_path = data["poster_path"] as? String else { continue }
			
			var overview:String = ""
			if let str = data["overview"] as? String, str != ""{
				overview = str
			}else{
				overview = "Overview not found"
			}
			
			let movie = MovieModel(id: id, posterPath: poster_path, title: title, overview: overview)
			
			self.movies?.append(movie)
		}
	}
}
