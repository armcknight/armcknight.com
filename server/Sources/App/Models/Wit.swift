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
    var description: String
    
    init(description: String) {
        self.description = description
    }
}

extension Wit: Migration {}
extension Wit: Content {}
extension Wit: Parameter {}
