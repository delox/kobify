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

struct ArtistsGateway: Mappable {
	
	var artists : [Artist]?
	
	// MARK: JSON
	init?(map: Map) { }
	
	mutating func mapping(map: Map) {
		artists <- map["artists.items"]
	}
	
}

struct Artist: Mappable {
	
	var name : String!
	var popularity : Int?
	var picture : String?
	var id : String?
	
	// MARK: JSON
	init?(map: Map) { }
	
	mutating func mapping(map: Map) {
		name <- map["name"]
		popularity <- map["popularity"]
		id <- map["id"]
		
		//Hack
		var t = [[String : Any]]()
		t <- map["images"]
		
		if let first = t.first?["url"] as? String {
			self.picture = first
		}
	}
	
}
