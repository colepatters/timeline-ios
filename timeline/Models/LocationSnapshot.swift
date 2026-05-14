//
//  LocationSnapshot.swift
//  timeline
//
//  Created by Cole Patterson on 10/4/25.
//

import Foundation
import SwiftData

@Model
class LocationSnapshot {
    var lat: Double
    var lon: Double
    var timestamp: Date
    var createdAt: Date = Date.now
    var systemTags: [String] = []

    init(lat: Double, lon: Double, timestamp: Date, createdAt: Date?, systemTags: [String]) {
        self.lat = lat
        self.lon = lon
        self.timestamp = timestamp
        self.createdAt = createdAt ?? Date.now
        self.systemTags = systemTags
    }
    
    static func fromDTO(_ dto: LocationSnapshotDTO) -> LocationSnapshot {
        return LocationSnapshot(
            lat: dto.lat,
            lon: dto.lon,
            timestamp: dto.timestamp,
            createdAt: dto.createdAt,
            systemTags: dto.systemTags
        )
    }
    
    func toDTO() -> LocationSnapshotDTO {
        return LocationSnapshotDTO(
            lat: self.lat,
            lon: self.lon,
            timestamp: self.timestamp,
            createdAt: self.createdAt
        )
    }
}
