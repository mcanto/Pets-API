//
//  MemberController.swift
//  App
//
//  Created by Mario Canto on 3/14/18.
//

import HTTP

final class MemberController {
		
	func store(_ request: Request) throws -> ResponseRepresentable {
		guard let json = request.json else {
			throw Abort.badRequest
		}		
		let member = try MemberModel(json: json)
		try member.save()
		return member
	}
	
	func show(_ req: Request, member: MemberModel) throws -> ResponseRepresentable {
		return member
	}
	
}

extension MemberController: ResourceRepresentable {
	
	func makeResource() -> Resource<MemberModel> {
		return Resource(store: store,
						show: show)
	}
}

extension MemberController: EmptyInitializable { }
