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
    
    var body: some View {
        Map {
            ForEach(places) { place in
                Marker(place.name, coordinate: CLLocationCoordinate2DMake(place.lat, place.lon))
            }
        }
    }
}

#Preview {
    MapView()
}
