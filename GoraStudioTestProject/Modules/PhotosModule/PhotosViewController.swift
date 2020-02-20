//
//  PhotosViewController.swift
//  GoraStudioTestProject
//
//  Created by Kirill Fedorov on 18.02.2020.
//  Copyright © 2020 Kirill Fedorov. All rights reserved.
//

import UIKit

protocol IPhotosViewController: class {
	func updateTableView()
	func stopActivityIndicator()
	func showAlert(withTitle title: String?, message: String?)
	func hideFooterLoader()
}

final class PhotosViewController: UIViewController {
	
	let presenter: IPhotosPresenter
	private let tableView = UITableView()
	private let activityIndicator = UIActivityIndicatorView(style: .large)
	private let spinner = UIActivityIndicatorView()
	
	init(presenter: IPhotosPresenter) {
		self.presenter = presenter
		super.init(nibName: nil, bundle: nil)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
    override func viewDidLoad() {
        super.viewDidLoad()
		view.backgroundColor = .white
		navigationItem.title = Constants.photosScreenTitle
		tableView.dataSource = self
		tableView.delegate = self
		tableView.register(PhotoCell.self, forCellReuseIdentifier: PhotoCell.reuseIdentifire)
		activityIndicator.startAnimating()
		setupViews()
    }
	
	private func setupViews() {
		tableView.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 0, right: 0)
		tableView.translatesAutoresizingMaskIntoConstraints = false
		tableView.separatorStyle = .none
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

extension PhotosViewController: UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return presenter.getPhotosCount()
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let cell = tableView.dequeueReusableCell(withIdentifier: PhotoCell.reuseIdentifire, for: indexPath)
			as? PhotoCell else { return UITableViewCell(style: .default, reuseIdentifier: "cell") }
		let photo = presenter.getPhoto(at: indexPath.row)
		cell.photo.setImage(fromUrl: photo.url)
		cell.descriptionLabel.text = photo.title
		cell.layoutSubviews()
		return cell
	}
	
	 func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
		let lastSectionIndex = tableView.numberOfSections - 1
		let lastRowIndex = tableView.numberOfRows(inSection: lastSectionIndex) - 1
		if indexPath.section ==  lastSectionIndex && indexPath.row == lastRowIndex {
			spinner.startAnimating()
			spinner.frame = CGRect(x: 0, y: 0, width: tableView.bounds.width, height: 44)
			tableView.tableFooterView = spinner
			tableView.tableFooterView?.isHidden = false
		}
	}

}

extension PhotosViewController: UITableViewDelegate {
	func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
		let currentOffset = scrollView.contentOffset.y
		let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height
		if maximumOffset - currentOffset <= 10.0 {
			presenter.loadMorePhotos()
			print("Load more photos")
		}
	}
}

extension PhotosViewController: IPhotosViewController {
	func stopActivityIndicator() {
		activityIndicator.stopAnimating()
	}
	
	func updateTableView() {
		tableView.reloadData()
	}
	
	func hideFooterLoader() {
		spinner.stopAnimating()
	}
	
	func showAlert(withTitle title: String?, message: String?) {
		let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
		let action = UIAlertAction(title: Constants.alertActionTitleOK, style: .default, handler: nil)
		alert.addAction(action)
		present(alert, animated: true, completion: nil)
	}
}

