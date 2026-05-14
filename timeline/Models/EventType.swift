//
//  EventType.swift
//  timeline
//
//  Created by Cole Patterson on 11/30/25.
//

import Foundation
import SwiftData

@Model
class EventType {
    @Attribute(.unique) var id: UUID = UUID()
    @Attribute(.unique) var name: String
    var createdAt: Date = Date.now
    
    init(name: String) {
        self.id = UUID()
        self.name = name
        self.createdAt = Date.now
    }
}
