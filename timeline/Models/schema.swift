//
//  schema.swift
//  timeline
//
//  Created by Cole Patterson on 12/19/25.
//

import SwiftData
import Foundation

public let globalDataSchema = Schema([
    Event.self,
    EventCategory.self,
    EventType.self,
    LocationSnapshot.self,
    LocationVisit.self,
    Place.self,
    Visit.self
])

public func ConfigureModelContainer() -> ModelContainer {
    let modelConfiguration = ModelConfiguration(schema: globalDataSchema, isStoredInMemoryOnly: false, cloudKitDatabase: .none)
    do {
        return try ModelContainer(for: globalDataSchema, configurations: [modelConfiguration])
    } catch {
        fatalError(error.localizedDescription)
    }
}

enum AppSchemaV1: VersionedSchema {
    static var versionIdentifier = Schema.Version(1, 0, 0)

    static var models: [any PersistentModel.Type] = [
        Event.self,
        EventCategory.self,
        EventType.self,
        LocationSnapshot.self,
        LocationVisit.self,
        Place.self,
        Visit.self,
    ]

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
    }

    @Model
    class Event {
        @Attribute(.unique) var id: UUID = UUID()
        @Attribute(.unique) var name: String
        var icon: String = "questionmark"
        var createdAt: Date = Date.now

        init(name: String) {
            self.id = UUID()
            self.name = name
            self.createdAt = Date.now
        }
    }

    @Model
    class EventCategory {
        @Attribute(.unique) var id: UUID = UUID()
        @Attribute(.unique) var name: String
        var createdAt: Date = Date.now
        var categories: [EventCategory] = []

        init(name: String) {
            self.id = UUID()
            self.name = name
            self.createdAt = Date.now
        }
    }

    @Model
    class EventType {
        @Attribute(.unique) var id: UUID = UUID()
        @Attribute(.unique) var name: String
        var createdAt: Date = Date.now

        init(name: String) {
            self.id = UUID()
            self.name = name
            self.createdAt = Date.now
        }
    }

    @Model
    class LocationVisit: Identifiable {
        @Attribute(.unique) var id: UUID = UUID()
        var lat: Double
        var lon: Double
        var arrivalDate: Date
        var departureDate: Date
        var createdAt: Date

        init(
            id: UUID?, lat: Double, lon: Double, arrivalDate: Date, departureDate: Date,
            createdAt: Date?
        ) {
            self.id = id ?? UUID()
            self.lat = lat
            self.lon = lon
            self.arrivalDate = arrivalDate
            self.departureDate = departureDate
            self.createdAt = createdAt ?? Date.now
        }
    }

    @Model
    class Place: Identifiable {

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
            return Place(
                id: UUID(uuidString: dto.id), name: dto.name, address: dto.address, lat: dto.lat,
                lon: dto.lon)
        }

        func toDTO() -> PlaceDTO {
            return PlaceDTO(
                id: self.id.uuidString, name: self.name, address: self.address, lat: self.lat,
                lon: self.lon)
        }

        static func findById(id: UUID, in context: ModelContext) throws -> [Place] {
            let result = try context.fetch(
                FetchDescriptor<Place>(
                    predicate: #Predicate { $0.id == id }
                ))

            print(result)

            return result
        }
    }
    
    @Model
    class PlaceCategory: Identifiable {
        @Attribute(.unique) var id: UUID = UUID()
        var name: String
        
        init(id: UUID?, name: String) {
            self.id = id ?? UUID()
            self.name = name
        }
        
        static func fromDTO(_ dto: PlaceCategoryDTO, in context: ModelContext) throws -> PlaceCategory {
            guard let uuid = UUID(uuidString: dto.id) else {
                throw PlaceCategoryFromDTOError.invalidUUID(uuidString: dto.id)
            }
            
            return PlaceCategory(id: uuid, name: dto.name)
        }
        
        func toDTO() -> PlaceCategoryDTO {
            return PlaceCategoryDTO(id: self.id.uuidString, name: self.name)
        }
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
            return VisitDTO(
                id: self.id.uuidString, placeId: self.place.id.uuidString, timestamp: self.timestamp
            )
        }
    }

}

/*
 
 Type Aliases
 
 */

typealias AppSchema = AppSchemaV1

//typealias Event = AppSchemaV1.Event
//typealias EventCategory = AppSchemaV1.EventCategory
//typealias EventType = AppSchemaV1.EventType
//typealias LocationSnapshot = AppSchemaV1.LocationSnapshot
//typealias LocationVisit = AppSchemaV1.LocationVisit
//typealias Place = AppSchemaV1.Place
//typealias Visit = AppSchemaV1.Visit
