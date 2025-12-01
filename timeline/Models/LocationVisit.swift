//
//  LocationVisit.swift
//  timeline
//
//  Created by Cole Patterson on 11/24/25.
//

import Foundation
import SwiftData

@Model
class LocationVisit: Identifiable {
    @Attribute(.unique) var id: UUID = UUID()
    var lat: Double
    var lon: Double
    var arrivalDate: Date
    var departureDate: Date
    var createdAt: Date
    
    init(id: UUID?, lat: Double, lon: Double, arrivalDate: Date, departureDate: Date, createdAt: Date?) {
        self.id = id ?? UUID()
        self.lat = lat
        self.lon = lon
        self.arrivalDate = arrivalDate
        self.departureDate = departureDate
        self.createdAt = createdAt ?? Date.now
    }
}
