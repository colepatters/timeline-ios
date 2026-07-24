//
//  timelineApp.swift
//  timeline
//
//  Created by Cole Patterson on 9/12/25.
//

import SwiftUI
import SwiftData
import CoreLocation

@main
struct timelineApp: App {
    private let container: ModelContainer
    @StateObject private var locationManager: LocationManager
    @State private var errorAlertQueue = ErrorAlertQueue()
    
    init() {
        do {
            let container = try ModelContainer(
                for: globalDataSchema
            )
            self.container = container
            
//            container.mainContext.insert(LogEntry(body: "model container created successfully", level: .info))
            
            _locationManager = StateObject(wrappedValue: LocationManager(modelContext: container.mainContext))
        } catch {
            fatalError()
        }
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(container)
        .environment(locationManager)
        .environment(errorAlertQueue)
    }
}
