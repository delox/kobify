//
//  ArtistCollectionViewCell.swift
//  Kobify
//
//  Created by Jose Solorzano on 3/15/17.
//  Copyright © 2017 José Solórzano. All rights reserved.
//

import UIKit
import AlamofireImage

class ArtistCollectionViewCell: UICollectionViewCell {
	
	
	@IBOutlet weak var imageView: UIImageView!
	@IBOutlet weak var nameLabel: UILabel!
	
	func clean() {
		self.imageView.image = nil
	}
	
	func configure(withArtist artist : Artist ) {
		if let image = artist.picture {
			if let imageURL = URL(string: image){
			
				self.imageView.af_setImage(withURL: imageURL)
				
			}
		}
		
		self.nameLabel.text = artist.name
	}
	
}
