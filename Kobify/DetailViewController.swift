//
//  DetailViewController.swift
//  Kobify
//
//  Created by Jose Solorzano on 3/15/17.
//  Copyright © 2017 José Solórzano. All rights reserved.
//

import UIKit
import AlamofireImage

class DetailViewController: UIViewController {

	@IBOutlet weak var imageView: UIImageView!
	@IBOutlet weak var detailDescriptionLabel: UILabel!
	@IBOutlet weak var tableView: UITableView!
	@IBOutlet weak var popularityLabel: UILabel!
	@IBOutlet weak var albumsLabel: UILabel!
	
	var albumsGateway : AlbumsGateway?
  let viewModel = DetailViewModel()

	func configureView() {
		if let artist = self.detailArtist {
			
			self.loadAlbums()
			
			if let popularity = artist.popularity {
				self.popularityLabel.text = "Followers: \(popularity)"
			}
			
			if let label = self.detailDescriptionLabel {
				label.text = artist.name
			}
			
			if let image = artist.picture {
				if let imageURL = URL(string: image){
					self.imageView.af_setImage(withURL: imageURL)
				}
			}
		}
	}
	
	func loadAlbums() {
		guard let artist = self.detailArtist else { return }
		guard let id = artist.id else { return }
		
		_ = self.viewModel.getAlbums(byArtistId: id).then { [unowned self] gateway -> Void in
			self.albumsGateway = gateway
			self.albumsLabel.text = "Albums: \(self.albumsGateway?.albums?.count ?? 0)"
			}.always {
				self.tableView.reloadData()
		}
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		self.title = ""
		self.tableView.dataSource = self
		self.tableView.delegate = self
		self.tableView.layoutMargins = UIEdgeInsets.zero
		self.tableView.tableFooterView = UIView()
		self.configureView()
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
	}

	var detailArtist: Artist?
}

extension DetailViewController : UITableViewDelegate {
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return 100
	}
}

extension DetailViewController : UITableViewDataSource {
	func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return self.albumsGateway?.albums?.count ?? 0
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "albumCell") as! AlbumTableViewCell
		
		cell.layoutMargins = UIEdgeInsets.zero
		cell.clean()
		
		if let album = self.albumsGateway?.albums?[indexPath.row] {
			cell.configure(withAlbum : album)
		}
		
		return cell
	}
}
