//
//  Factory.swift
//  GoraStudioTestProject
//
//  Created by Kirill Fedorov on 18.02.2020.
//  Copyright © 2020 Kirill Fedorov. All rights reserved.
//

import Foundation

final class Factory {
	
	private let repository = Repository(dataLoader: DataLoader())
	
	func createUsersModule() -> UsersViewController {
		let router = UsersRouter(factory: self)
		let presenter = UsersPresenter(repository: repository, router: router)
		let usersViewController = UsersViewController(presenter: presenter)
		presenter.usersViewController = usersViewController
		router.usersViewController = usersViewController
		return usersViewController
	}
	
	func createPhotosVC(for user: User) -> PhotosViewController {
		let presenter = PhotosPresenter(user: user, repository: repository)
		let photosVC = PhotosViewController(presenter: presenter)
		presenter.photosViewController = photosVC
		return photosVC
	}
}
