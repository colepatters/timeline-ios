//
//  LocationSnapshot.swift
//  timeline
//
//  Created by Cole Patterson on 10/4/25.
//

import Foundation
import SwiftData

@Model
class LocationSnapshot: Codable {
    // required to conform to Codable
    enum codingKeys: CodingKey {
        case lat, lon, timestamp
    }
    
    var lat: Double
    var lon: Double
    var timestamp: Date
    
    init(lat: Double, lon: Double, timestamp: Date) {
        self.lat = lat
        self.lon = lon
        self.timestamp = timestamp
    }
    
    // required to conform to Codable
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: codingKeys.self)
        self.lat = try container.decode(Double.self, forKey: codingKeys.lat)
        self.lon = try container.decode(Double.self, forKey: codingKeys.lon)
        self.timestamp = try container.decode(Date.self, forKey: codingKeys.timestamp)
    }
    
    // required to conform to Codable
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: codingKeys.self)
        try container.encode(lat, forKey: .lat)
        try container.encode(lon, forKey: .lon)
        try container.encode(timestamp, forKey: .timestamp)
    }
}
