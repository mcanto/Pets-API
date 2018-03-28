//
//  PetController.swift
//  App
//
//  Created by Mario Canto on 3/14/18.
//

import HTTP

final class PetController {
	
	func store(_ request: Request) throws -> ResponseRepresentable {
		guard let json = request.json else {
			throw Abort.badRequest
		}
		
		
		let pet = try PetModel(json: json)		
		
		try pet.save()
		return pet
	}
	
	func show(_ req: Request, pet: PetModel) throws -> ResponseRepresentable {
		return pet
	}
}

extension PetController: ResourceRepresentable {
	
	func makeResource() -> Resource<PetModel> {
		return Resource(store: store,
						show: show)
	}
}

extension PetController: EmptyInitializable { }
