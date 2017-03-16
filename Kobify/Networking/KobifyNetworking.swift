//
//  KobifyNetworking.swift
//  Kobify
//
//  Created by Jose Solorzano on 3/15/17.
//  Copyright © 2017 José Solórzano. All rights reserved.
//

import Foundation
import Moya

enum KobifyWebService {
	case searchArtist(name: String)
	case getArtist(id : String)
	case getAlbums(id : String)
}

extension KobifyWebService: TargetType {
	
	var baseURL: URL { return URL(string: "https://api.spotify.com/v1")! }
	
	var path: String {
		switch self {
		case .searchArtist(_):
			return "/search"
		case .getArtist(let artist):
			return "/artists/\(artist)"
		case .getAlbums(let id):
			return "/artists/\(id)/albums"
		}
	}
	
	var method: Moya.Method {
		return .get
	}
	
	var parameters: [String: Any]? {
		switch self {
		case .searchArtist(let name):
			return ["q" : name, "type" : "artist"]
		default:
			return nil
		}
	}
	
	var parameterEncoding: ParameterEncoding {
		return URLEncoding.default
	}
	
	var sampleData: Data {
		switch self {
			
		case .searchArtist(_):
			return Data()
		case .getArtist(_):
			return Data()
		case .getAlbums(_):
			return Data()
		}
	}
	
	var task: Task {
			return .request
	}
}

let kobifyNetworkingProvider : MoyaProvider<KobifyWebService> = MoyaProvider()
