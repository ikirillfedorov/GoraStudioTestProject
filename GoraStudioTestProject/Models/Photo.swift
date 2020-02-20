//
//  Photo.swift
//  MyProject
//
//  Created by Kirill Fedorov on 17.02.2020.
//  Copyright © 2020 Kirill Fedorov. All rights reserved.
//

import Foundation

struct Photo: Decodable {
	let albumId: Int
	let id: Int
	let title: String
	let url: String
	let thumbnailUrl: String
}
