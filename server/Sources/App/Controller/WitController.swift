//
//  WitController.swift
//  App
//
//  Created by Andrew McKnight on 9/30/18.
//

import Foundation
import Routing
import Vapor

final class WitController {
    func create(_ req: Request) throws -> Future<Response> {
        return try req.content.decode(Wit.self).flatMap { wit in
            return wit.save(on: req).map(to: Response.self) { _ in
                return req.redirect(to: "/")
            }
        }
    }
    
    func list(_ req: Request) -> Future<[Wit]> {
        return Wit.query(on: req).all()
    }
}
