//
//  Visit.swift
//  timeline
//
//  Created by Cole Patterson on 10/5/25.
//

import Foundation
import SwiftData

@Model
class Visit: Codable {
    enum CodingKeys: CodingKey {
        case id, place, timestamp
    }
    
    @Attribute(.unique) var id: UUID = UUID()
    var place: Place
    var timestamp: Date
    
    init(id: UUID?, place: Place, timestamp: Date) {
        self.id = id ?? UUID()
        self.place = place
        self.timestamp = timestamp
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(UUID.self, forKey: .id)
        self.place = try container.decode(Place.self, forKey: .place)
        self.timestamp = try container.decode(Date.self, forKey: .timestamp)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(place, forKey: .place)
        try container.encode(timestamp, forKey: .timestamp)
    }
}
