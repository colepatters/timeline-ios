//
//  PlacePicker.swift
//  timeline
//
//  Created by Cole Patterson on 10/5/25.
//

import SwiftUI
import SwiftData
import MapKit

func findDistance(x1: Double, y1: Double, x2: Double, y2: Double) -> Double {
    let dx = x2 - x1
    let dy = y2 - y1
    let distance = sqrt(pow(dx, 2) + pow(dy, 2))
    return distance
}

func sortPlacesByDistance(places: [Place], userLocation: CLLocation) -> [Place] {
    let userCoordinate = userLocation.coordinate
    
    var sortedPlaces = places
    sortedPlaces.sort {
        let placeCoordinate = UnitPoint(x: $0.lat, y: $0.lon)
        let nextPlaceCoordinate = UnitPoint(x: $1.lat, y: $1.lon)
        
        return findDistance(x1: placeCoordinate.x, y1: placeCoordinate.y, x2: userLocation.coordinate.latitude, y2: userCoordinate.longitude) < findDistance(x1: nextPlaceCoordinate.x, y1: nextPlaceCoordinate.y, x2: userLocation.coordinate.latitude, y2: userCoordinate.longitude)
    }
    
    return sortedPlaces
}

struct PlacePicker: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @Environment(LocationManager.self) var locationManager: LocationManager
    
    @Query var places: [Place]
    
    @State private var searchQuery: String = ""
    var sortByDistance: Bool = false
    
    var externalSelectionHandler: ((_ place: Place) -> Void)?
    
    var body: some View {
        
        if (sortByDistance && locationManager.manager.location != nil) {
            List(sortPlacesByDistance(places: filteredPlaces(places: places, searchText: searchQuery), userLocation: locationManager.manager.location!)) { place in
                Button {
                    handleSelection(place: place)
                } label: {
                    VStack(alignment: .leading) {
                        Text(place.name).font(.headline)
                        Text(place.address).font(.subheadline)
                    }
                }
            }
            .searchable(text: $searchQuery)
            .onAppear {
                if sortByDistance {
                    locationManager.manager.requestLocation()
                }
            }
        } else {
            List(filteredPlaces(places: places, searchText: searchQuery)) { place in
                Button {
                    handleSelection(place: place)
                } label: {
                    VStack(alignment: .leading) {
                        Text(place.name).font(.headline)
                        Text(place.address).font(.subheadline)
                    }
                }
            }
            .searchable(text: $searchQuery)
        }
    }
    
    func handleSelection(place: Place) {
        if (externalSelectionHandler != nil) {
            externalSelectionHandler!(place)
        }
        dismiss()
    }
}

#Preview {
    let modelContainer = try! ModelContainer.sample()
    let locationManager: LocationManager = LocationManager(modelContext: modelContainer.mainContext)

    PlacePicker(sortByDistance: true)
        .modelContainer(modelContainer)
        .environment(locationManager)
}
