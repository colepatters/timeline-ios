//
//  LocationSnapshot.swift
//  timeline
//
//  Created by Cole Patterson on 10/4/25.
//

import Foundation
import SwiftData

typealias LocationSnapshot = LocationSnapshotSchemaV2.LocationSnapshot

/*
 
 README!!
 
 schemas are technically versioned, but only for historical reference (so far). complex migrations are not set up. to pick back up and finish real versions you'll have to move every model into a versioned schema (yikes) (i'm not doing that at 12.14am).
 
 */

enum LocationSnapshotSchemaV2: VersionedSchema {
    static var versionIdentifier = Schema.Version(2, 0, 0)
    
    static var models: [any PersistentModel.Type] {
        [ LocationSnapshot.self ]
    }
    
    @Model
    class LocationSnapshot {
        var lat: Double
        var lon: Double
        var timestamp: Date
        var createdAt: Date = Date.now
        var systemTags: [ String ] = []
        
        init(lat: Double, lon: Double, timestamp: Date, createdAt: Date?, systemTags: [String]) {
            self.lat = lat
            self.lon = lon
            self.timestamp = timestamp
            self.createdAt = createdAt ?? Date.now
            self.systemTags = systemTags
        }
    }
}

enum LocationSnapshotSchemaV1: VersionedSchema {
    static var versionIdentifier = Schema.Version(1, 0, 0)
    
    static var models: [any PersistentModel.Type] {
        [ LocationSnapshot.self ]
    }
    
    @Model
    class LocationSnapshot {
        var lat: Double
        var lon: Double
        var timestamp: Date
        
        init(lat: Double, lon: Double, timestamp: Date) {
            self.lat = lat
            self.lon = lon
            self.timestamp = timestamp
        }
    }
}


