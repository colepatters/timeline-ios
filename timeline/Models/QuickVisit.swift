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
}
