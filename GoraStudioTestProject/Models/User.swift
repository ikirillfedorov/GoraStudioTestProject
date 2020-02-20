//
//  User.swift
//  MyProject
//
//  Created by Kirill Fedorov on 17.02.2020.
//  Copyright © 2020 Kirill Fedorov. All rights reserved.
//

import Foundation

struct User: Decodable {
	let id: Int
	let name: String
	let email: String
	let address: Address
	let website: String
	let company: Company
}


struct Address: Decodable {
	let street: String
	let suite: String
	let city: String
	let zipcode: String
	let geo: Geo
}

struct Geo: Decodable {
	let lat: String
	let lng: String
}

struct Company: Decodable {
	let name: String
	let catchPhrase: String
	let bs: String
}
