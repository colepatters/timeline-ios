//
//  MapView.swift
//  timeline
//
//  Created by Cole Patterson on 11/18/25.
//

import SwiftUI
import MapKit
import SwiftData

struct MapView: View {
    
    @Query var places: [Place]
    
    @State private var userLocation: CLLocation?
    
    @Environment(LocationManager.self) var locationManager: LocationManager
    
    var body: some View {
        Map {
            ForEach(places) { place in
                Marker(place.name, coordinate: CLLocationCoordinate2DMake(place.lat, place.lon))
            }
            
            UserAnnotation(anchor: .center)
        }
        .mapControls {
            MapUserLocationButton()
        }
        .onAppear {
            locationManager.manager.requestLocation()
            userLocation = locationManager.manager.location
        }
    }
}

#Preview {
    MapView()
}
