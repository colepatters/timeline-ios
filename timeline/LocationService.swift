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
        print("location get failed with error")
        print(error)
    }
    
    func locationManager(_ manager: CLLocationManager, didVisit visit: CLVisit) {
        let visit = LocationVisit(id: nil, lat: visit.coordinate.latitude, lon: visit.coordinate.longitude, arrivalDate: visit.arrivalDate, departureDate: visit.departureDate, createdAt: Date.now)
        modelContext.insert(visit)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("locations updated")
        for location in locations {
            let snapshot = LocationSnapshot(lat: location.coordinate.latitude, lon: location.coordinate.longitude, timestamp: location.timestamp, createdAt: Date.now, systemTags: [])
            modelContext.insert(snapshot)
        }
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedWhenInUse:  // Location services are available.
            print("location auth success (while in use)")
            break
            
        case .restricted, .denied:  // Location services currently unavailable.
            print("location auth restricted or denied")
            break
            
        case .notDetermined:        // Authorization not determined yet.
           manager.requestWhenInUseAuthorization()
            break
            
        default:
            break
        }
    }
}
