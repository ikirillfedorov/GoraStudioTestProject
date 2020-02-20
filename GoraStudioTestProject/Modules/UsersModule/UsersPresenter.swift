//
//  UsersPresenter.swift
//  GoraStudioTestProject
//
//  Created by Kirill Fedorov on 18.02.2020.
//  Copyright © 2020 Kirill Fedorov. All rights reserved.
//

import Foundation

protocol IUsersPresenter {
	func getUsersCount() -> Int
	func getUser(at index: Int) -> User
	func showPhotosForUser(at index: Int)
}

final class UsersPresenter {
	
	weak var usersViewController: IUsersViewController?
	private let repository: IRepository
	private let router: IUsersRouter
	private var users: [User] = []
	
	init(repository: IRepository, router: IUsersRouter) {
		self.repository = repository
		self.router = router
		setupUsers()
	}
}

extension UsersPresenter: IUsersPresenter {
	func getUsersCount() -> Int {
		return users.count
	}
	
	func getUser(at index: Int) -> User {
		return users[index]
	}
	
	func showPhotosForUser(at index: Int) {
		router.showPhotosVC(for: users[index])
	}
	
	func setupUsers() {
		repository.getUsers() { [weak self] usersResult in
			guard let self = self else { return }
			switch usersResult {
			case .success(let users):
				DispatchQueue.main.async { [weak self] in
				guard let self = self else { return }
					self.users = users
					self.usersViewController?.stopActivityIndicator()
					self.usersViewController?.updateTableView()
				}
			case .failure(let error):
				DispatchQueue.main.async { [weak self] in
				guard let self = self else { return }
					self.usersViewController?.showAlert(withTitle: Constants.alertTitle, message: error.localizedDescription)
					self.usersViewController?.stopActivityIndicator()
				}
			}
		}
	}
}
