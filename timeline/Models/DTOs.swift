//
//  DTOs.swift
//  timeline
//
//  Created by Cole Patterson on 1/23/26.
//

import Foundation

struct LocationSnapshotDTO: Codable {
    var lat: Double
    var lon: Double
    var timestamp: Date
    var createdAt: Date
    var systemTags: [String] = []
}

struct LocationVisitDTO: Identifiable, Codable {
    var id: String
    var lat: Double
    var lon: Double
    var arrivalDate: Date
    var departureDate: Date
    var createdAt: Date
}

enum PlaceCategoryFromDTOError: Error {
    case invalidUUID(uuidString: String)
}

struct PlaceCategoryDTO {
    var id: String
    var name: String
}
