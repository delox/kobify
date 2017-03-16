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

class MasterViewModel {
	
	private func getArtist(
		name: String,
		success successCallBack: @escaping (ArtistsGateway) -> Void,
		error errorCallback: @escaping (_ error: Moya.Error) -> Void
		) {
		
		kobifyNetworkingProvider.request(.searchArtist(name: name)) { (result) in
			
			switch result {
			case let .success(response):
				do {
					let gateway = try response.mapObject(ArtistsGateway.self)
					successCallBack(gateway)
				} catch {
					errorCallback(.jsonMapping(response))
				}
				
			case let .failure(error):
				errorCallback(error)
			}
		}
	}
	
	public func search(artistByName name : String) -> Promise<ArtistsGateway> {
		
		return Promise { fulfill, reject in
			
			self.getArtist(name: name, success: { (gateway) in
				return fulfill(gateway)
			}, error: { (error) in
				return reject(error)
			})
			
		}
	}
}
