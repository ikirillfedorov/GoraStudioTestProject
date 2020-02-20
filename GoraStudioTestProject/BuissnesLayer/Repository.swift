//
//  Repository.swift
//  GoraStudioTestProject
//
//  Created by Kirill Fedorov on 18.02.2020.
//  Copyright © 2020 Kirill Fedorov. All rights reserved.
//

import Foundation

typealias UsersResult = Result<[User], Error>
typealias AlbumsResult = Result<[Album], Error>
typealias PhotosResult = Result<[Photo], Error>

protocol IRepository {
	func getUsers(completion: @escaping (UsersResult) -> ())
	func getAlbums(userId: Int, completion: @escaping (AlbumsResult) -> ())
	func getPhotos(albumId: Int, completion: @escaping (PhotosResult) -> ())
}

final class Repository {
	enum Error: Swift.Error, LocalizedError {
		case canNotMakeUrl
		public var errorDescription: String? {
			switch self {
			case .canNotMakeUrl:
				return NSLocalizedString("Wrong address", comment: "Can't make url")
			}
		}
	}

	let dataLoader: DataLoader
	var users: [User] = []
	
	init(dataLoader: DataLoader) {
		self.dataLoader = dataLoader
	}
}

extension Repository: IRepository {
	func getUsers(completion: @escaping (UsersResult) -> ()) {
		getResult(url: dataLoader.usersUrl, responseType: [User].self, completion: completion)
	}
	
	func getAlbums(userId: Int, completion: @escaping (AlbumsResult) -> ()) {
		let albumsUrl = dataLoader.getAlbumsUrl(userId: userId)
		getResult(url: albumsUrl, responseType: [Album].self, completion: completion)
	}

	func getPhotos(albumId: Int, completion: @escaping (PhotosResult) -> ()) {
		let photosUrl = dataLoader.getPhotosUrl(albumId: albumId)
		getResult(url: photosUrl, responseType: [Photo].self, completion: completion)
	}

	private func getResult<T: Decodable>(url: URL?, responseType: T.Type, completion: @escaping (Result<T, Swift.Error>) -> ()) {
		guard let url = url else { return completion(.failure(Error.canNotMakeUrl)) }
		dataLoader.fetchData(url: url) { dataResult in
			switch dataResult {
			case .success(let data):
				do {
					let photos = try JSONDecoder().decode(responseType, from: data)
					completion(.success(photos))
				} catch {
					completion(.failure(error))
				}
			case .failure(let error):
				completion(.failure(error))
			}
		}
	}
}
