//
//  WebImageView.swift
//  MyProject
//
//  Created by Kirill Fedorov on 17.02.2020.
//  Copyright © 2020 Kirill Fedorov. All rights reserved.
//

import UIKit

final class WebImageView: UIImageView {
	
	private var currentUrlString: String?
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		setupViews()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	let activityIndicator: UIActivityIndicatorView = {
		let indicator = UIActivityIndicatorView()
		indicator.translatesAutoresizingMaskIntoConstraints = false
		indicator.startAnimating()
		return indicator
	}()

	private func setupViews() {
		addSubview(activityIndicator)
		activityIndicator.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
		activityIndicator.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
	}
	
	func setImage(fromUrl: String?) {
		currentUrlString = fromUrl
		guard let imageUrl = fromUrl, let url = URL(string: imageUrl) else {
			self.image = nil
			return }
		
		if let cachedResponse = URLCache.shared.cachedResponse(for: URLRequest(url: url)) {
			self.image = UIImage(data: cachedResponse.data)
			activityIndicator.stopAnimating()
			return
		}

		let dataTask = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
			guard let self = self, let data = data, let response = response else { return }
			DispatchQueue.main.async {
				self.handleLoadedImage(data: data, response: response)
				self.activityIndicator.stopAnimating()
			}
		}
		dataTask.resume()
	}
	
	private func handleLoadedImage(data: Data, response: URLResponse) {
		guard let responseUrl = response.url else { return }
		let cachedResponse = CachedURLResponse(response: response, data: data)
		URLCache.shared.storeCachedResponse(cachedResponse, for: URLRequest(url: responseUrl))
		if responseUrl.absoluteString == currentUrlString {
			self.image = UIImage(data: data)
		}
	}
}
