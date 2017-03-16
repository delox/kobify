//
//  Artist.swift
//  Kobify
//
//  Created by Jose Solorzano on 4/15/17.
//  Copyright © 2017 José Solórzano. All rights reserved.
//

import Foundation
import ObjectMapper

// MARK: Initializer and Properties

struct AlbumsGateway: Mappable {
	
	var albums : [Album]?
	
	// MARK: JSON
	init?(map: Map) { }
	
	mutating func mapping(map: Map) {
		albums <- map["items"]
	}
	
}

struct Album: Mappable {
	
	var name : String!
	var picture : String?
	
	// MARK: JSON
	init?(map: Map) { }
	
	mutating func mapping(map: Map) {
		name <- map["name"]
		
		//Hack
		var t = [[String : Any]]()
		t <- map["images"]
		
		if let first = t.first?["url"] as? String {
			self.picture = first
		}
	}
	
}
