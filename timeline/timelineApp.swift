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
                for: LocationSnapshot.self, Place.self, Visit.self,
            )
            self.container = container
            _locationManager = StateObject(wrappedValue: LocationManager(modelContext: container.mainContext))
        } catch {
            fatalError()
        }
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(self.container)
        .environment(locationManager)
        .environment(errorAlertQueue)
    }
}
