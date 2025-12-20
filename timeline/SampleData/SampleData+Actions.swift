//
//  SampleData+Actions.swift
//  timeline
//
//  Created by Cole Patterson on 10/4/25.
//

import Foundation
import SwiftData

func insertSampleData(modelContext: ModelContext) {
    for entry in sampleLocationSnapshots {
        modelContext.insert(entry)
    }
    for entry in samplePlaces {
        modelContext.insert(entry)
    }
    for entry in sampleVisits {
        modelContext.insert(entry)
    }
    modelContext.insert(Event(name: "Move"))
    modelContext.insert(Event(name: "Breakup"))
}

func reloadSampleData(modelContext: ModelContext) {
    do {
        try modelContext.delete(model: LocationSnapshot.self)
        insertSampleData(modelContext: modelContext)
    } catch {
        fatalError(error.localizedDescription)
    }
}
