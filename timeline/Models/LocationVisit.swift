//
//  LocationVisit.swift
//  timeline
//
//  Created by Cole Patterson on 11/24/25.
//

import Foundation
import SwiftData

// TODO when moving to the monolith schema, rename to clVisit or something

@Model
class LocationVisit: Identifiable {
    var id: UUID
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
    
    static func fromDTO(_ dto: LocationVisitDTO) -> LocationVisit {
        let id = UUID(uuidString: dto.id)
        
        return LocationVisit(
            id: id,
            lat: dto.lat,
            lon: dto.lon,
            arrivalDate: dto.arrivalDate,
            departureDate: dto.departureDate,
            createdAt: dto.createdAt
        )
    }
    
    func toDTO() -> LocationVisitDTO {
        return LocationVisitDTO(
            id: self.id.uuidString,
            lat: self.lat,
            lon: self.lon,
            arrivalDate: self.arrivalDate,
            departureDate: self.departureDate,
            createdAt: self.createdAt
        )
    }
}
