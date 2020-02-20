//
//  DataLoader.swift
//  MyProject
//
//  Created by Kirill Fedorov on 17.02.2020.
//  Copyright © 2020 Kirill Fedorov. All rights reserved.
//

import Foundation

typealias DataResult = Result<Data, Error>

final class DataLoader {
	var usersUrl: URL? {
		let components = makeBaseComponents()
		components.path = Constants.Endpoint.usersPath
		return components.url
	}

	func getPhotosUrl(albumId: Int) -> URL? {
		let components = makeBaseComponents()
		components.path = Constants.Endpoint.photosPath
		components.queryItems = [URLQueryItem(name: Constants.QueryKey.albumId, value: "\(albumId)")]
		return components.url
	}

	func getAlbumsUrl(userId: Int) -> URL? {
		let components = makeBaseComponents()
		components.path = Constants.Endpoint.albumsPath
		components.queryItems = [URLQueryItem(name: Constants.QueryKey.userId, value: "\(userId)")]
		return components.url
	}
	
	func fetchData(url: URL, completion: @escaping (DataResult) -> Void) {
		URLSession.shared.dataTask(with: url) { (data, response, error) in
			if let error = error {
				completion(.failure(error))
				return
			}
			guard let data = data else { return }
			completion(.success(data))
		}.resume()
	}

	private func makeBaseComponents() -> NSURLComponents {
		let components = NSURLComponents()
		components.scheme = Constants.Endpoint.scheme
		components.host = Constants.Endpoint.host
		return components
	}
}

extension DataLoader {
	enum Constants {
		enum Endpoint {
			static let scheme = "https"
			static let host = "jsonplaceholder.typicode.com"
			static let usersPath = "/users"
			static let albumsPath = "/albums"
			static let photosPath = "/photos"
		}

		enum QueryKey {
			static let albumId = "albumId"
			static let userId = "userId"
		}
	}
}
