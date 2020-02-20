//
//  UsersRouter.swift
//  GoraStudioTestProject
//
//  Created by Kirill Fedorov on 18.02.2020.
//  Copyright © 2020 Kirill Fedorov. All rights reserved.
//

import Foundation

protocol IUsersRouter {
	func showPhotosVC(for user: User)
}

final class UsersRouter {
	weak var usersViewController: UsersViewController?
	private let factory: Factory

	init(factory: Factory) {
		self.factory = factory
	}
}

extension UsersRouter: IUsersRouter {

	func showPhotosVC(for user: User) {
		let photosVC = factory.createPhotosVC(for: user)
		usersViewController?.navigationController?.pushViewController(photosVC, animated: true)
	}
}
