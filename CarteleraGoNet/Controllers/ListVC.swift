//
//  ListVC.swift
//  CarteleraGoNet
//
//  Created by Giovanny Bonifaz on 05/10/20.
//

import UIKit

class ListVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
	
	@IBOutlet weak var menuSC: UISegmentedControl!
	@IBOutlet weak var table: UITableView!
	@IBOutlet weak var buttonsSV: UIStackView!
	@IBOutlet weak var cleanBtn: UIButton!
	@IBOutlet weak var startBtn: UIButton!
	
	var movieList = MovieList()
	var threads:[String] = []
		
	let group = DispatchGroup()
	let queueArray = DispatchQueue(label: "com.sgba.threads")
	let operationQueue = OperationQueue()
	
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		table.dataSource = self
		table.delegate = self
		
		self.movieList.getData(success: {
			self.table.reloadData()
		}, failure: { print("failed at \(#file) \(#function) \(#line)") })
    }
    
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		AppUtility.lockOrientation(.portrait, andRotateTo: .portrait)
	}
	
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		
		AppUtility.lockOrientation(.allButUpsideDown)
	}
	
	func setThreads() {
		let opLow = BlockOperation { [weak self] in
			for i in 0..<10001{
				self?.group.enter()
				self?.queueArray.async(group: self?.group, flags: .barrier) {
					print("🥶", i)
					self?.threads.append("Thread A | Low Priority | \(i)")
					self?.group.leave()
				}
				
			}
		}
		opLow.queuePriority = .low
		
		let opNormal = BlockOperation { [weak self] in
			for i in 0..<10001{
				self?.queueArray.async(group: self?.group, flags: .barrier) {
					print("😐", i)
					self?.threads.append("Thread B | Medium Priority | \(i)")
				}
			}
		}
		opNormal.queuePriority = .normal
		
		let opHigh = BlockOperation { [weak self] in
			for i in 0..<10001{
				self?.group.enter()
				self?.queueArray.async(flags: .barrier) {
					print("🥵", i)
					self?.threads.append("Thread C | High Priority | \(i)")
					self?.group.leave()
				}
			}
		}
		opHigh.queuePriority = .high
		
		opHigh.addDependency(opNormal)
		
		operationQueue.addOperations([opLow, opNormal, opHigh], waitUntilFinished: true)
	}

	@IBAction func changeView(_ sender: UISegmentedControl) {
		table.reloadData()
	}
	
	@IBAction func startThreads(_ sender: UIButton) {
		self.setThreads()
		
		table.reloadData()
		self.startBtn.isHidden = true
		self.cleanBtn.isHidden = false
	}
	
	@IBAction func cleanThreads(_ sender: UIButton) {
		threads.removeAll()
		table.reloadData()
		self.startBtn.isHidden = false
		self.cleanBtn.isHidden = true
	}
	
	func numberOfSections(in tableView: UITableView) -> Int {
		return 2
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		var rows = 0
		if section == 0 && menuSC.selectedSegmentIndex == 0 {
			rows = movieList.movies?.count ?? 0
			buttonsSV.isHidden = true
		} else if section == 1 && menuSC.selectedSegmentIndex == 1 {
			rows = threads.count
			buttonsSV.isHidden = false
		}
		return rows
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		if indexPath.section == 0 {
			let cell = tableView.dequeueReusableCell(withIdentifier: "cell1", for: indexPath) as! MovieCell
			
			if let movie = movieList.movies?[indexPath.row] {
				cell.set(movie: movie)
			}
			return cell
		}else{
			let cell = tableView.dequeueReusableCell(withIdentifier: "cell2", for: indexPath) as! ThreadCell
			cell.textLbl.text = threads[indexPath.row]
			return cell
		}
	}
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier == "showDetail", let destination = segue.destination as? MovieDetailVC, let row = table.indexPathForSelectedRow?.row {
			
			destination.movie = movieList.movies?[row]
		}
	}
}
