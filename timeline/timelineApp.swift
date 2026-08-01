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
    private let appContext: AppContext?
    
    init() {
        self.appContext = AppContext()
    }
    
    var body: some Scene {
        WindowGroup {
            if (appContext == nil) {
                Text("app context could not be created")
            } else {
                ContentView()
                    .modelContainer(appContext!.modelContainer)
                    .environment(appContext!)
            }
        }
    }
}

class AppContext: Observable {
    
    var modelContainer: ModelContainer
    var locationManager: LocationManager
    var errorAlertQueue: ErrorAlertQueue
    
    init?() {
        do {
            self.modelContainer = try ModelContainer(for: globalDataSchema)
        } catch {
            return nil
        }
        
        self.locationManager = LocationManager(modelContext: self.modelContainer.mainContext)
        self.errorAlertQueue = ErrorAlertQueue()
    }
    
}
