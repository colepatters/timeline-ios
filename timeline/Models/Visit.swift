//
//  Visit.swift
//  timeline
//
//  Created by Cole Patterson on 10/5/25.
//

import Foundation
import SwiftData

enum VisitFromDTOError: Error {
    case invalidUUID(uuidString: String)
    case placeNotFound(placeId: String)
}

struct VisitDTO: Codable, Identifiable {
    var id: String
    var placeId: String
    var timestamp: Date
}

@Model
class Visit: Identifiable {
    enum CodingKeys: CodingKey {
        case id, place, timestamp
    }
    
    @Attribute(.unique) var id: UUID = UUID()
    @Relationship() var place: Place
    var timestamp: Date
    
    init(id: UUID?, place: Place, timestamp: Date) {
        self.id = id ?? UUID()
        self.place = place
        self.timestamp = timestamp
    }
    
    static func fromDTO(_ dto: VisitDTO, in context: ModelContext) throws -> Visit {
        guard let visitUUID = UUID(uuidString: dto.id) else {
            throw VisitFromDTOError.invalidUUID(uuidString: dto.id)
        }
        
        guard let placeUUID = UUID(uuidString: dto.placeId) else {
            throw VisitFromDTOError.invalidUUID(uuidString: dto.id)
        }
        
        var fetch = FetchDescriptor<Place>(predicate: #Predicate { $0.id == placeUUID })
        fetch.fetchLimit = 1
        guard let place = try context.fetch(fetch).first else {
            throw VisitFromDTOError.placeNotFound(placeId: dto.placeId)
        }
        
        return Visit(id: visitUUID, place: place, timestamp: dto.timestamp)
    }
    
    func toDTO() -> VisitDTO {
        return VisitDTO(id: self.id.uuidString, placeId: self.place.id.uuidString, timestamp: self.timestamp)
    }
}
