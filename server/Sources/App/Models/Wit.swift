//
//  Wit.swift
//  App
//
//  Created by Andrew McKnight on 9/30/18.
//

import FluentPostgreSQL
import Foundation
import Vapor

final class Wit: PostgreSQLModel {
    var id: Int?
    var timestamp: Date?
    var description: String
    
    init(description: String) {
        self.description = description
    }
}

extension Wit: Migration {
    static func prepare(on conn: PostgreSQLConnection) -> Future<Void> {
        return Database.create(Wit.self, on: conn) { builder in
            builder.field(for: \.id, isIdentifier: true)
            builder.field(for: \.description)
            builder.field(for: \.timestamp, type: .timestamptz, .default(.function("Now")))
        }
    }
}

extension Wit: Content {}
extension Wit: Parameter {}
