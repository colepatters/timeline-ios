//
//  Place.swift
//  timeline
//
//  Created by Cole Patterson on 10/4/25.
//

import Foundation
import SwiftData

@Model
class Place: Codable {
    // required to conform to Codable
    enum CodingKeys: CodingKey {
        case id, name, address, lat, lon
    }
    
    @Attribute(.unique) var id: UUID = UUID()
    var name: String
    var address: String
    var lat: Double
    var lon: Double
    
    init(id: UUID?, name: String, address: String, lat: Double, lon: Double) {
        self.id = id ?? UUID()
        self.name = name
        self.address = address
        self.lat = lat
        self.lon = lon
    }
    
    // required to conform to Codable
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(UUID.self, forKey: .id)
        self.name = try container.decode(String.self, forKey: .name)
        self.address = try container.decode(String.self, forKey: .address)
        self.lat = try container.decode(Double.self, forKey: .lat)
        self.lon = try container.decode(Double.self, forKey: .lon)
    }
    
    // required to conform to Codable
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(address, forKey: .address)
        try container.encode(lat, forKey: .lat)
        try container.encode(lon, forKey: .lon)
    }
}
