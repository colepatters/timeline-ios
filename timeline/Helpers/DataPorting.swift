//
//  DataPorting.swift
//  timeline
//
//  Created by Cole Patterson on 7/25/26.
//

import Foundation
import SwiftData

class ModelDataDTO: Codable {
    let schamaVersion: Double

    let locationSnapshots: [LocationSnapshotDTO]
    let locationVisits: [LocationVisitDTO]
    let logEntries: [LogEntryDTO]
    let places: [PlaceDTO]
    let quickVisits: [QuickVisitDTO]
    let visits: [VisitDTO]

    init(
        schamaVersion: Double, locationSnapshots: [LocationSnapshotDTO],
        locationVisits: [LocationVisitDTO], logEntries: [LogEntryDTO], places: [PlaceDTO],
        quickVisits: [QuickVisitDTO], visits: [VisitDTO]
    ) {
        self.schamaVersion = schamaVersion
        self.locationSnapshots = locationSnapshots
        self.locationVisits = locationVisits
        self.logEntries = logEntries
        self.places = places
        self.quickVisits = quickVisits
        self.visits = visits
    }
}

class ModelData {
    let schemaVersion = 1.0

    // TODO
    //    let events: [ Event ] = []
    //    let eventCategories: [ EventCategory ] = []
    //    let eventTypes: [ EventType ] = []

    let locationSnapshots: [LocationSnapshot]
    let locationVisits: [LocationVisit]
    let logEntries: [LogEntry]
    let places: [Place]
    let quickVisits: [QuickVisit]
    let visits: [Visit]
    
    init(
        locationSnapshots: [LocationSnapshot],
        locationVisits: [LocationVisit], logEntries: [LogEntry], places: [Place],
        quickVisits: [QuickVisit], visits: [Visit]
    ) {
        self.locationSnapshots = locationSnapshots
        self.locationVisits = locationVisits
        self.logEntries = logEntries
        self.places = places
        self.quickVisits = quickVisits
        self.visits = visits
    }

    static func importFromJSON(json: String) {

    }

    func exportToJSON() throws -> Data {
        let encoder = getJSONEncoder()

        return try encoder.encode(self.toDTO())
    }

    func toDTO() -> ModelDataDTO {
        return ModelDataDTO(
            schamaVersion: self.schemaVersion,
            locationSnapshots: self.locationSnapshots.map { e in e.toDTO() },
            locationVisits: self.locationVisits.map { e in e.toDTO() },
            logEntries: self.logEntries.map { e in e.toDTO() },
            places: self.places.map { e in e.toDTO() },
            quickVisits: self.quickVisits.map { e in e.toDTO() },
            visits: self.visits.map { e in e.toDTO() },
        )
    }
}

enum DataExportError: Error {
    case dataToStringFail
}

func allDataToJSON(modelContext: ModelContext) throws -> JsonFile {
    let locationSnapshots = try modelContext.fetch(FetchDescriptor<LocationSnapshot>())
    let locationVisits = try modelContext.fetch(FetchDescriptor<LocationVisit>())
    let logEntries = try modelContext.fetch(FetchDescriptor<LogEntry>())
    let places = try modelContext.fetch(FetchDescriptor<Place>())
    let quickVisits = try modelContext.fetch(FetchDescriptor<QuickVisit>())
    let visits = try modelContext.fetch(FetchDescriptor<Visit>())
    
    let data = try ModelData(
        locationSnapshots: locationSnapshots,
        locationVisits: locationVisits,
        logEntries: logEntries,
        places: places,
        quickVisits: quickVisits,
        visits: visits
    ).exportToJSON()
    
    let jsonString = String(data: data, encoding: .utf8)
    
    if (jsonString == nil) {
        throw DataExportError.dataToStringFail
    }
    
    return JsonFile(initialText: jsonString!)
}
