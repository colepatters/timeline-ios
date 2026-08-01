//
//  NearbyPlacePicker.swift
//  timeline
//
//  Created by Cole Patterson on 11/28/25.
//

import SwiftUI
import SwiftData
import MapKit

struct NearbyPlacePicker: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(ErrorAlertQueue.self) private var errorAlertQueue
    @Environment(LocationManager.self) private var locationManager
    
    @State private var searching: Bool = true
    @State private var mapItems: [ MKMapItem ] = []
    
    @State private var showSheet: Bool = true
    
    var handleSelect: ((_ mapItem: MKMapItem) -> Void)?
    
    @State private var cameraPosition: MapCameraPosition = .camera(
        MapCamera(
            centerCoordinate: CLLocationCoordinate2D(latitude: 0, longitude: 0),
            distance: 1000,
            heading: 10,
            pitch: 0
        )
    )
    
    var body: some View {
        NavigationStack {
            Map(position: $cameraPosition) {
                UserAnnotation()
                
                ForEach(mapItems.enumerated(), id: \.offset) { index, mapItem in
                    Marker("", monogram: Text("1"), coordinate: mapItem.location.coordinate)
                }
            }
                .sheet(isPresented: $showSheet) {
                    ZStack {
                        if (searching) {
                            VStack {
                                ProgressView()
                            }
                        }
                        
                        if (searching == false && mapItems.count == 0) {
                            Text("¯\\_(ツ)_/¯")
                        } else {
                            List(mapItems.enumerated(), id: \.offset) { index, mapItem in
                                Button {
                                    if (handleSelect != nil) {
                                        handleSelect!(mapItem)
                                        dismiss()
                                    }
                                } label: {
                                    HStack {
                                        Text("\(index)")
                                        
                                        VStack(alignment: .leading) {
                                            Text(mapItem.name ?? "no name")
                                            Text(mapItem.address?.fullAddress ?? "")
                                                .font(.subheadline)
                                        }
                                    }
                                }
                            }
                        }
                    }
                    .presentationDetents([ .height(400) ])
                    .presentationBackgroundInteraction(.enabled)
                    .interactiveDismissDisabled()
                }
        }
        .onAppear {
            Task {
                do {
                    searching = true
                    
                    if (locationManager.manager.location == nil) {
                        errorAlertQueue.append(
                            ErrorAlert(
                                title: "unable to fetch nearby places",
                                message: "looks like we don't have your location, please make sure you have the location service enabled and you're allowing timeline to access your location"
                            )
                        )
                        return
                    }
                    
                    let userPositionCoordinates = locationManager.manager.location!.coordinate
                    
                    cameraPosition = .camera(.init(
                        centerCoordinate: CLLocationCoordinate2D(
                            latitude: userPositionCoordinates.latitude - 0.005,
                            longitude: userPositionCoordinates.longitude
                        ),
                        distance: 5000
                    ))
                    
                    let request = MKLocalPointsOfInterestRequest(
                        center: locationManager.manager.location!.coordinate,
                        radius: 100
                    )
                    let result = try await MKLocalSearch(request: request).start()
                    
                    mapItems = result.mapItems
                    
                    searching = false
                } catch {
                    searching = false
                    
                }
            }
        }
    }
}

#Preview {
    let modelContainer = try! ModelContainer.sample()
    let locationManager: LocationManager = LocationManager(modelContext: modelContainer.mainContext)
    let alertQueue = ErrorAlertQueue()
    
    NavigationStack {
        NearbyPlacePicker()
            .modelContainer(modelContainer)
            .environment(locationManager)
            .environment(alertQueue)
    }
}
