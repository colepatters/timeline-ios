//
//  LocationService.swift
//  timeline
//
//  Created by Cole Patterson on 9/13/25.
//

import Foundation
import CoreLocation
internal import Combine
import SwiftData

class LocationManager: Observable, ObservableObject {
    let manager: CLLocationManager
    let delegate: LocationServiceDelegate
    let modelContext: ModelContext
    
    var backgroundActivitySession: CLBackgroundActivitySession?
    var authSession: CLServiceSession?
    var monitor: CLMonitor?
    
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
        self.delegate = LocationServiceDelegate(modelContext: modelContext)
        
        let manager = CLLocationManager()
        manager.allowsBackgroundLocationUpdates = true
        manager.distanceFilter = 20
//        manager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        
        self.manager = manager
        manager.delegate = self.delegate
    }
}

class LocationServiceDelegate: NSObject, CLLocationManagerDelegate {
    private let modelContext: ModelContext
    
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: any Error) {
        print("failed to get device's location")
        print(error)
        
        modelContext.insert(
            LogEntry(
                title: "[LocationManager] failed to get device's location",
                body: error.localizedDescription,
                level: .error
            )
        )
    }
    
    func locationManager(_ manager: CLLocationManager, didVisit visit: CLVisit) {
        modelContext.insert(
            LogEntry(body: "[LocationManager] app became aware of new CLVisit, processing...")
        )
        
        var existingVisit: LocationVisit? = nil
        
        do {
            let results = try modelContext.fetch(FetchDescriptor<LocationVisit>())
            let filtered = results.filter { result in
                // TODO also match the location coordinates
                return result.arrivalDate == visit.arrivalDate && result.departureDate == Date.distantFuture
            }
            
            if (filtered.first != nil) {
                modelContext.insert(
                    LogEntry(
                        title: "[LocationManager] found a CLVisit that matches the arrival date and has not accurate end date",
                        body: "new visit arrival: \(visit.arrivalDate.formatted()), new visit departure: \(visit.departureDate.formatted()), match visit arrival: \(filtered.first!.arrivalDate.formatted()), match visit departure: \(filtered.first!.departureDate.formatted())"
                    )
                )
                
                existingVisit = filtered.first
            }
        } catch {
            print(error)
            modelContext.insert(
                LogEntry(
                    title: "[LocationManager] an error occured while finding a LocationVisit that matches a new visit",
                    body: error.localizedDescription,
                    level: .error
                )
            )
        }
        
        if (existingVisit == nil) {
            modelContext.insert(
                LogEntry(body: "[LocationManager] new CLVisit doesn't match any previously created, inserting as new entry")
            )
            
            modelContext.insert(
                LocationVisit(
                    id: nil,
                    lat: visit.coordinate.latitude,
                    lon: visit.coordinate.longitude,
                    arrivalDate: visit.arrivalDate,
                    departureDate: visit.departureDate,
                    createdAt: Date.now
                )
            )
        } else {
            existingVisit!.departureDate = visit.departureDate
            
            do {
                try modelContext.save()
            } catch {
                modelContext.insert(
                    LogEntry(
                        title: "[LocationManager] failed to save model context after updating matched visit's departureDate",
                        body: error.localizedDescription,
                        level: .error
                    )
                )
            }
        }
        
        modelContext.insert(LogEntry(body: "[LocationManager] CLVisit saved into model context"))
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("locations updated")
        modelContext.insert(LogEntry(body: "[LocationManager] locations updated"))
        
        for location in locations {
            let snapshot = LocationSnapshot(lat: location.coordinate.latitude, lon: location.coordinate.longitude, timestamp: location.timestamp, createdAt: Date.now, systemTags: [])
            modelContext.insert(snapshot)
        }
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedWhenInUse:  // Location services are available.
            print("location auth success (while in use)")
            modelContext.insert(LogEntry(body: "[LocationManager] location auth success (while in use)"))
            break
            
        case .restricted, .denied:  // Location services currently unavailable.
            print("location auth restricted or denied")
            modelContext.insert(LogEntry(body: "[LocationManager] location auth restricted or denied"))
            break
            
        case .notDetermined:        // Authorization not determined yet.
            manager.requestWhenInUseAuthorization()
            break
            
        default:
            break
        }
    }
}
