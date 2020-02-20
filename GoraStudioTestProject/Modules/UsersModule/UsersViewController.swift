//
//  UsersViewController.swift
//  GoraStudioTestProject
//
//  Created by Kirill Fedorov on 18.02.2020.
//  Copyright © 2020 Kirill Fedorov. All rights reserved.
//

import UIKit

protocol IUsersViewController: class {
	func updateTableView()
	func stopActivityIndicator()
	func showAlert(withTitle title: String?, message: String?)
}

class UsersViewController: UIViewController {

	private let presenter: IUsersPresenter
	private let reuseIdentifier = "UserCell"
	private let tableView = UITableView()
	private let activityIndicator = UIActivityIndicatorView(style: .large)

	init(presenter: IUsersPresenter) {
		self.presenter = presenter
		super.init(nibName: nil, bundle: nil)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		navigationItem.title = Constants.usersScreenTitle
		view.backgroundColor = .white
		tableView.dataSource = self
		tableView.delegate = self
		activityIndicator.startAnimating()
		setupViews()
	}
	
	private func setupViews() {
		tableView.translatesAutoresizingMaskIntoConstraints = false
		activityIndicator.translatesAutoresizingMaskIntoConstraints = false
		view.addSubview(tableView)
		view.addSubview(activityIndicator)
		NSLayoutConstraint.activate([
			tableView.topAnchor.constraint(equalTo: view.topAnchor),
			tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
			tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
			tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
			
			activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
			activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
		])
	}
}

extension UsersViewController: IUsersViewController {
	func stopActivityIndicator() {
		activityIndicator.stopAnimating()
	}
	
	func updateTableView() {
		tableView.reloadData()
	}
}

extension UsersViewController: UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return presenter.getUsersCount()
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier) ?? UITableViewCell(style: .default, reuseIdentifier: reuseIdentifier)
		let user = presenter.getUser(at: indexPath.row)
		cell.textLabel?.text = user.name
		return cell
	}
	
	func showAlert(withTitle title: String?, message: String?) {
		let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
		let action = UIAlertAction(title: Constants.alertActionTitleOK, style: .default, handler: nil)
		alert.addAction(action)
		present(alert, animated: true, completion: nil)
	}
}

extension UsersViewController: UITableViewDelegate {
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: true)
		presenter.showPhotosForUser(at: indexPath.row)
	}
}
