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

@Observable class LocationService: NSObject, ObservableObject, CLLocationManagerDelegate {
    private var manager = CLLocationManager()
    
    var servicesEnabled: Bool = false
    
    override init() {
        super.init()
        manager.delegate = self
        self.servicesEnabled = CLLocationManager.locationServicesEnabled()
    }
    
    func requestLocation() {
        manager.requestLocation()
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        print("location authorization changed.")
    }
    
    func didUpdateLocations(_ manager: CLLocationManager, locations: [CLLocation]) {
        print("Locations updated.")
    }
    
    
}
