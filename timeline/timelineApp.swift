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
    let db: Database
    @State var locationService = LocationService()
    
    init() {
        do {
            let database = try Database()
            db = database
        } catch {
            fatalError()
        }
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(self.db.container)
        .environment(locationService)
    }
}
