//
//  Place.swift
//  timeline
//
//  Created by Cole Patterson on 10/4/25.
//

import Foundation
import SwiftData

struct PlaceDTO: Codable, Identifiable {
    var id: String
    var name: String
    var address: String
    var lat: Double
    var lon: Double
}

@Model
class Place: Identifiable {
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
    
    static func fromDTO(dto: PlaceDTO) -> Place {
        return Place(id: UUID(uuidString: dto.id), name: dto.name, address: dto.address, lat: dto.lat, lon: dto.lon)
    }
    
    func toDTO() -> PlaceDTO {
        return PlaceDTO(id: self.id.uuidString, name: self.name, address: self.address, lat: self.lat, lon: self.lon)
    }
    
    static func findById(id: UUID, in context: ModelContext) throws -> [Place] {
        let result = try context.fetch(FetchDescriptor<Place>(
            predicate: #Predicate { $0.id == id }
        ))
        
        print(result)
        
        return result
    }
}
