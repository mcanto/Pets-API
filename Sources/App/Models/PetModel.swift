//
//  Pet.swift
//  PetsPackageDescription
//
//  Created by Mario Canto on 3/13/18.
//

import FluentProvider

final class PetModel: Model {
		
	// MARK:- Attributes
	
	let name: String
	let isLost: Bool	
	let ownerId: Identifier?
	
	// MARK:- Model
	
	lazy var storage: Storage = {
		return $0
	}(Storage())
	
	func makeRow() throws -> Row {
		var row = Row()
		try row.set(PetModel.Keys.name, name)
		try row.set(PetModel.Keys.isLost, isLost)
		try row.set(MemberModel.foreignIdKey, ownerId)
		return row
	}
	
	init(row: Row) throws {
		self.name = try row.get(PetModel.Keys.name)
		self.isLost = try row.get(PetModel.Keys.isLost)
		self.ownerId = try row.get(PetModel.Keys.ownerId)
	}
	
	// MARK:- Initializer
	
	public init(name: String, isLost: Bool, owner: MemberModel) {
        self.name = name
        self.isLost = isLost
		self.ownerId = owner.id
    }	
}

extension PetModel {
	
	var owner: Parent<PetModel, MemberModel> {
		return parent(id: id)
	}
}

extension PetModel: Timestampable {}

extension PetModel: Preparation {
	
	// MARK:- Preparation
	static func prepare(_ database: Database) throws {
		try database.create(self) { creator in
			creator.parent(MemberModel.self)
			creator.id()
			creator.string(PetModel.Keys.name)
			creator.bool(PetModel.Keys.isLost)
		}
	}
	
	static func revert(_ database: Database) throws {
		try database.delete(self)
	}
}

extension PetModel: JSONRepresentable {
	
	convenience init(json: JSON) throws {
		let memberId: Identifier = try json.get(PetModel.Keys.ownerId)
		guard let owner = try MemberModel.find(memberId) else {
			throw Abort.badRequest
		}
		self.init(name: try json.get(PetModel.Keys.name),
				  isLost: try json.get(PetModel.Keys.isLost),
				  owner: owner)
	}
	
	func makeJSON() throws -> JSON {
		var json = JSON()
		try json.set(PetModel.Keys.id, id)
		try json.set(PetModel.Keys.name, name)
		try json.set(PetModel.Keys.isLost, isLost)
		try json.set(PetModel.Keys.ownerId, ownerId)
		return json
	}
}

extension PetModel: ResponseRepresentable {}

extension PetModel {
	
	// MARK:- Attribute Keys
	private struct Keys {
		static let id = "id"
		static let name = "name"
		static let isLost = "is_lost"
		static let ownerId = "owner_id"
	}
}
