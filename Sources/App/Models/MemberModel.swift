//
//  Member.swift
//  App
//
//  Created by Mario Canto on 3/14/18.
//

import FluentProvider

final class MemberModel: Model {
	
	// MARK:- Attributes
	
	let username: String
	let firstName: String
	let lastName: String
	let mobilePhone: String
	let email: String
	
	// MARK:- Model
	
	lazy var storage: Storage = {
		return $0
	}(Storage())
	
	func makeRow() throws -> Row {
		var row = Row()
		try row.set(MemberModel.Keys.username, username)
		try row.set(MemberModel.Keys.firstName, firstName)
		try row.set(MemberModel.Keys.lastName, lastName)
		try row.set(MemberModel.Keys.mobilePhone, mobilePhone)
		try row.set(MemberModel.Keys.email, email)
		
		return row
	}
	
	init(row: Row) throws {
		self.username = try row.get(MemberModel.Keys.username)
		self.firstName = try row.get(MemberModel.Keys.firstName)
		self.lastName = try row.get(MemberModel.Keys.lastName)
		self.mobilePhone = try row.get(MemberModel.Keys.mobilePhone)
		self.email = try row.get(MemberModel.Keys.email)
	}
	
	// MARK:- Initializer
	
	init(username: String, firstName: String, lastName: String, mobilePhone: String, email: String) {
		self.username = username
		self.firstName = firstName
		self.lastName = lastName
		self.mobilePhone = mobilePhone
		self.email = email
	}
}

extension MemberModel {
	var pets: Children<MemberModel, PetModel> {
		return children()
	}	
}

extension MemberModel: Timestampable {}

extension MemberModel: Preparation {
	
	// MARK:- Preparation
	static func prepare(_ database: Database) throws {
		try database.create(self) { creator in
			creator.id()
			creator.string(MemberModel.Keys.username)
			creator.string(MemberModel.Keys.firstName)
			creator.string(MemberModel.Keys.lastName)
			creator.string(MemberModel.Keys.mobilePhone)
			creator.string(MemberModel.Keys.email)
		}
	}
	
	static func revert(_ database: Database) throws {
		try database.delete(self)
	}
}

extension MemberModel: JSONRepresentable {
	
	convenience init(json: JSON) throws {
		self.init(username: try json.get(MemberModel.Keys.username),
				  firstName: try json.get(MemberModel.Keys.firstName),
				  lastName: try json.get(MemberModel.Keys.lastName),
				  mobilePhone: try json.get(MemberModel.Keys.mobilePhone),
				  email: try json.get(MemberModel.Keys.email))
	}
	
	func makeJSON() throws -> JSON {
		var json = JSON()
		try json.set(MemberModel.Keys.id, id)
		try json.set(MemberModel.Keys.username, username)
		try json.set(MemberModel.Keys.firstName, firstName)
		try json.set(MemberModel.Keys.lastName, lastName)
		try json.set(MemberModel.Keys.mobilePhone, mobilePhone)
		try json.set(MemberModel.Keys.email, email)
		
		return json
	}
}

extension MemberModel: ResponseRepresentable {}


extension MemberModel {
	
	// MARK:- Attribute Keys
	private struct Keys {
		static let id = "id"
		static let username = "username"
		static let firstName = "firstName"
		static let lastName = "lastName"
		static let mobilePhone = "mobilePhone"
		static let email = "email"
	}
}
