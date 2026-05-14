//
//  EventCategory.swift
//  timeline
//
//  Created by Cole Patterson on 12/8/25.
//

import Foundation
import SwiftData

@Model
class EventCategory {
    @Attribute(.unique) var id: UUID = UUID()
    @Attribute(.unique) var name: String
    var createdAt: Date = Date.now
    var categories: [ EventCategory ] = []
    
    init(name: String) {
        self.id = UUID()
        self.name = name
        self.createdAt = Date.now
    }
}
