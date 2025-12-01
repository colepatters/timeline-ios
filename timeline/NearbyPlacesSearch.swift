//
//  NearbyPlacesSearch.swift
//  timeline
//
//  Created by Cole Patterson on 11/27/25.
//

import Foundation
import MapKit

enum NearbyPlacesSearchError: Error {
    case userLocationUnavailable
    case searchError(message: String)
}


class NearbyPlacesSearchSource {
    var isSearching: Bool = false
    var manager: CLLocationManager
    var search: MKLocalSearch?
    var results: [ MKMapItem ] = []
    
    init(manager: CLLocationManager) {
        self.manager = manager
    }
    
    func search() async throws -> Void {
        self.isSearching = true
        
        if manager.location == nil {
            throw NearbyPlacesSearchError.userLocationUnavailable
        }
        
        let request = MKLocalPointsOfInterestRequest(center: manager.location!.coordinate, radius: 10.0)
        self.search = MKLocalSearch(request: request)
        
        do {
            let response = try await self.search!.start()
            self.results = response.mapItems
        } catch let error {
            self.isSearching = false
            throw NearbyPlacesSearchError.searchError(message: "Unable to prefrom search: \(error)")
        }
        
        self.isSearching = false
    }
}
