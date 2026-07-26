//
//  QuickVisit.swift
//  timeline
//
//  Created by Cole Patterson on 7/25/26.
//

import Foundation
import SwiftData

enum QuickVisitSource: String, Codable {
    case clvisit = "clvisit"
    case widget = "widget"
    case app = "app"
//    case web = "web"
//    case webhook = "webhook"
}

class QuickVisitDTO: Identifiable, Codable {
    var id: String
    
    var arrival: Date
    var departure: Date?
    
    var lat: Double
    var lon: Double
    
    var source: QuickVisitSource
    var createdAt: Date
    
    init(id: String, arrival: Date, departure: Date?, lat: Double, lon: Double, source: QuickVisitSource, createdAt: Date) {
        self.id = id
        self.arrival = arrival
        self.departure = departure
        self.lat = lat
        self.lon = lon
        self.source = source
        self.createdAt = createdAt
    }
}

@Model
class QuickVisit: Identifiable {
    
    @Attribute(.unique) var id: UUID = UUID()
    
    var arrival: Date
    var departure: Date?
    
    var lat: Double
    var lon: Double
    
    var source: QuickVisitSource
    var createdAt: Date
    
    init(arrival: Date, source: QuickVisitSource, lat: Double, lon: Double) {
        self.arrival = arrival
        self.departure = nil
        self.lat = lat
        self.lon = lon
        self.source = source
        self.createdAt = Date.now
    }
    
    init(arrival: Date, departure: Date, source: QuickVisitSource, lat: Double, lon: Double) {
        self.arrival = arrival
        self.departure = departure
        self.lat = lat
        self.lon = lon
        self.source = source
        self.createdAt = Date.now
    }
    
    func toDTO() -> QuickVisitDTO {
        return QuickVisitDTO(
            id: self.id.uuidString,
            arrival: self.arrival,
            departure: self.departure,
            lat: self.lat,
            lon: self.lon,
            source: self.source,
            createdAt: self.createdAt
        )
    }
}
