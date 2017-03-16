//
//  MasterViewModel.swift
//  Kobify
//
//  Created by Jose Solorzano on 3/15/17.
//  Copyright © 2017 José Solórzano. All rights reserved.
//

import Foundation
import PromiseKit
import Moya

class DetailViewModel {
	
	private func getAlbums(
		id: String,
		success successCallBack: @escaping (AlbumsGateway) -> Void,
		error errorCallback: @escaping (_ error: Moya.Error) -> Void
		) {
		
		kobifyNetworkingProvider.request(.getAlbums(id: id)) { (result) in
			
			switch result {
			case let .success(response):
				do {
					let gateway = try response.mapObject(AlbumsGateway.self)
					successCallBack(gateway)
				} catch {
					errorCallback(.jsonMapping(response))
				}
				
			case let .failure(error):
				errorCallback(error)
			}
		}
	}
	
	public func getAlbums(byArtistId id: String) -> Promise<AlbumsGateway> {
		
		return Promise { fulfill, reject in
			
			self.getAlbums(id: id, success: { (gateway) in
				return fulfill(gateway)
			}, error: { (error) in
				return reject(error)
			})
			
		}
	}
}
