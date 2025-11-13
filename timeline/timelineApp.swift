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
    static let container: ModelContainer = try! ModelContainer(for: LocationSnapshot.self, Place.self, Visit.self)
    @State var locationService = LocationService()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(Self.container)
        .environment(locationService)
    }
}
