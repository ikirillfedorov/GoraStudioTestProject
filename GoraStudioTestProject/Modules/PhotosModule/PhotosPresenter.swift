//
//  PhotosPresenter.swift
//  GoraStudioTestProject
//
//  Created by Kirill Fedorov on 18.02.2020.
//  Copyright © 2020 Kirill Fedorov. All rights reserved.
//

import Foundation

protocol IPhotosPresenter {
	func getPhotosCount() -> Int
	func getPhoto(at index: Int) -> Photo
	func loadMorePhotos()
}

final class PhotosPresenter {
	
	weak var photosViewController: IPhotosViewController?
	private let repository: IRepository
	private let user: User
	private var albums: [Album] = []
	private var photos: [Photo] = []
	private let dispatchGroup = DispatchGroup()
	private var currentAlbumIndex = 0

	init(user: User, repository: IRepository) {
		self.user = user
		self.repository = repository
		setupPhotos()
	}
}

extension PhotosPresenter: IPhotosPresenter {
	func getPhotosCount() -> Int {
		return photos.count
	}
	
	func getPhoto(at index: Int) -> Photo {
		return photos[index]
	}
	
	func loadMorePhotos() {
		loadPhotos(albumIndex: currentAlbumIndex)
		currentAlbumIndex += 1
	}

	
	func setupPhotos() {
		dispatchGroup.enter()
		print("dispatchGroup.enter")
		repository.getAlbums(userId: user.id) { [weak self] albumsResult in
			guard let self = self else { return }
			switch albumsResult {
			case .success(let albums):
				DispatchQueue.main.async {  [weak self] in
					guard let self = self else { return }
					self.albums = albums
					print("albums downloaded")
					self.dispatchGroup.leave()
					print("dispatchGroup.leave")
					if albums.count > self.currentAlbumIndex {
						self.loadPhotos(albumIndex: self.currentAlbumIndex)
						self.currentAlbumIndex += 1
					}
				}
			case .failure(let error):
				DispatchQueue.main.async {  [weak self] in
					guard let self = self else { return }
					self.photosViewController?.showAlert(withTitle: Constants.alertTitle, message: error.localizedDescription)
					self.photosViewController?.stopActivityIndicator()
				}
			}
		}
	}
	
	func loadPhotos(albumIndex: Int) {
		print("load photos from user labum # \(albumIndex) / 10")
		guard (albums.count - 1) >= albumIndex else { return }
		dispatchGroup.notify(queue: DispatchQueue.global()) {
			self.repository.getPhotos(albumId: self.albums[albumIndex].id) { [weak self] photosResult in
				guard let self = self else { return }
				switch photosResult {
				case .success(let photos):
					DispatchQueue.main.async { [weak self] in
					guard let self = self else { return }
						self.photos += photos
						self.photosViewController?.updateTableView()
						self.photosViewController?.stopActivityIndicator()
						self.photosViewController?.hideFooterLoader()
						print("photos downloaded - photos \(self.photos.count)")
					}
				case .failure(let error):
					DispatchQueue.main.async { [weak self] in
					guard let self = self else { return }
						self.photosViewController?.showAlert(withTitle: Constants.alertTitle, message: error.localizedDescription)
						self.photosViewController?.stopActivityIndicator()
						self.photosViewController?.hideFooterLoader()
					}
				}
			}
		}
	}
}
