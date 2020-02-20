//
//  PhotoCell.swift
//  MyProject
//
//  Created by Kirill Fedorov on 17.02.2020.
//  Copyright © 2020 Kirill Fedorov. All rights reserved.
//

import UIKit

class PhotoCell: UITableViewCell {
	
	let cardView: UIView = {
		let view = UIView()
		view.translatesAutoresizingMaskIntoConstraints = false
		view.clipsToBounds = true
		view.layer.cornerRadius = 10
		view.layer.borderColor = UIColor.lightGray.cgColor
		view.layer.borderWidth = 1
		return view
	}()
	
	let photo: WebImageView = {
		let imageView = WebImageView(frame: .zero)
		imageView.translatesAutoresizingMaskIntoConstraints = false
		imageView.contentMode = .scaleAspectFit
		return imageView
	}()
	
	let descriptionLabel: UILabel = {
		let label = UILabel()
		label.numberOfLines = 0
		label.translatesAutoresizingMaskIntoConstraints = false
		let insets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
		return label
	}()
	
	static let reuseIdentifire = "PhotoCell"

	override func prepareForReuse() {
		photo.setImage(fromUrl: nil)
		descriptionLabel.text = nil
		photo.activityIndicator.startAnimating()
	}
	
	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		self.backgroundColor = .clear
		self.selectionStyle = .none
		addSubViews()
		setConstarints()
		setShadow()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	private func addSubViews() {
		contentView.addSubview(cardView)
		cardView.addSubview(photo)
		cardView.addSubview(descriptionLabel)
	}
	
	private func setShadow() {
		layer.shadowRadius = 3
		layer.shadowOpacity = 0.4
		layer.shadowOffset = CGSize(width: 2.5, height: 3)
	}
	private func setConstarints() {
		NSLayoutConstraint.activate([
			cardView.topAnchor.constraint(equalTo: contentView.topAnchor),
			cardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
			cardView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
			cardView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12),

			photo.topAnchor.constraint(equalTo: cardView.topAnchor),
			photo.leadingAnchor.constraint(equalTo: cardView.leadingAnchor),
			photo.trailingAnchor.constraint(equalTo: cardView.trailingAnchor),
			photo.heightAnchor.constraint(equalTo: photo.widthAnchor),
			
			descriptionLabel.topAnchor.constraint(equalTo: photo.bottomAnchor, constant: 8),
			descriptionLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 8),
			descriptionLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -8),
			descriptionLabel.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -8),
		])
	}
}
