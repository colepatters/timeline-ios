//
//  Preview+ModelContainer.swift
//  timeline
//
//  Created by Cole Patterson on 10/4/25.
//

import SwiftData

extension ModelContainer {
    static var sample: () throws -> ModelContainer = {
        let schema = Schema([LocationSnapshot.self, Place.self, Visit.self])
        let configuration = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: schema, configurations: [configuration])
        Task { @MainActor in
            insertSampleData(modelContext: container.mainContext)
        }
        return container
    }
}
