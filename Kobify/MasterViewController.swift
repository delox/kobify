//
//  MasterViewController.swift
//  Kobify
//
//  Created by Jose Solorzano on 3/15/17.
//  Copyright © 2017 José Solórzano. All rights reserved.
//

import UIKit
import ObjectMapper
import Moya
import Moya_ObjectMapper

class MasterViewController: UIViewController {

	var detailViewController: DetailViewController? = nil
	var artistsGateway : ArtistsGateway?
	var throttler : Timer?
	let viewModel = MasterViewModel()

	@IBOutlet weak var searchBar: UISearchBar!
	@IBOutlet weak var collectionView: UICollectionView!

	override func viewDidLoad() {
		super.viewDidLoad()

		if let split = self.splitViewController {
		    let controllers = split.viewControllers
		    self.detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
		}
		
		collectionView.delegate = self
		collectionView.dataSource = self
		searchBar.delegate = self
		
		let imageView = UIImageView(image: UIImage(named : "logo"))
		let frame = self.navigationController?.navigationBar.frame ?? CGRect.zero
		imageView.frame = frame
		imageView.contentMode = .scaleAspectFit
		self.navigationItem.titleView = imageView
	}
	
	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		
		self.navigationItem.titleView?.frame = self.navigationController?.navigationBar.frame ?? CGRect.zero
	}
	
	func searchArtists() {
		
		guard let searchTerm = self.searchBar.text, (self.searchBar.text ?? "").characters.count > 0 else { return }
		
		_ = viewModel.search(artistByName: searchTerm).then { [unowned self] foundGateway -> Void in
			self.artistsGateway = foundGateway

		}.always {
			self.collectionView.reloadData()
		}
	}

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}

	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier == "showDetail" {
		    if let indexPath = self.collectionView?.indexPathsForSelectedItems?.first {
					if let artist = artistsGateway?.artists?[indexPath.item] {
						let controller = (segue.destination as! UINavigationController).topViewController as! DetailViewController
						controller.detailArtist = artist
						controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem
						controller.navigationItem.leftItemsSupplementBackButton = true
					}
		    }
		}
	}
}

extension MasterViewController {
	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		super.touchesBegan(touches, with: event)
		self.searchBar.endEditing(true)
	}
}

extension MasterViewController : UICollectionViewDataSource {
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "artistCell", for: indexPath) as! ArtistCollectionViewCell
		
		cell.clean()
		
		if let artist = artistsGateway?.artists?[indexPath.item] {
		   cell.configure(withArtist: artist)
		}
		
		cell.backgroundColor = UIColor.clear
		return cell
		
	}
	
	func numberOfSections(in collectionView: UICollectionView) -> Int {
		return 1
	}
	
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return artistsGateway?.artists?.count ?? 0
	}
}

extension MasterViewController : UICollectionViewDelegate {
	
	
	
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		self.performSegue(withIdentifier: "showDetail", sender: indexPath)
	}
}

extension MasterViewController : UISearchBarDelegate {
	func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
		self.throttler?.invalidate()
		self.throttler = Timer.scheduledTimer(withTimeInterval: 0.4, repeats: false, block: { [unowned self] (timer) in
			self.searchArtists()
		})
	}
}
