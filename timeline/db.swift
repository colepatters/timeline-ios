//
//  db.swift
//  timeline
//
//  Created by Cole Patterson on 11/17/25.
//

import Foundation
import SwiftData

final class Database {
    let container: ModelContainer
    
    init() throws {
        container = try ModelContainer(for: LocationSnapshot.self, Place.self, Visit.self)
    }
}
