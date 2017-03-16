//
//  AlbumTableViewCell.swift
//  Kobify
//
//  Created by Jose Solorzano on 3/16/17.
//  Copyright © 2017 José Solórzano. All rights reserved.
//

import UIKit

class AlbumTableViewCell: UITableViewCell {
	
	@IBOutlet weak var coverView: UIImageView!
	
	@IBOutlet weak var nameLabel: UILabel!
	
	func clean() {
		self.coverView.image = nil
	}
	
	func configure(withAlbum album : Album) {
		if let picture = album.picture {
			if let imageURL = URL(string: picture) {
				self.coverView.af_setImage(withURL: imageURL)
			}
		}
		
		self.nameLabel.text = album.name
	}
	
	override func awakeFromNib() {
		super.awakeFromNib()
	}
	
	override func setSelected(_ selected: Bool, animated: Bool) {
		super.setSelected(selected, animated: animated)
	}
	
}
