//
//  MapView.swift
//  timeline
//
//  Created by Cole Patterson on 11/18/25.
//

import SwiftUI
import MapKit
import SwiftData

private struct MapItemSelectionDetailsSheet: View {
    
    var place: Place?
    var feature: MapSelection<MKMapItem>?
    
    var handleDismiss: () -> Void
    
    init(place: Place? = nil, feature: MapSelection<MKMapItem>? = nil, _ handleDismiss: @escaping () -> Void) {
        self.place = place
        self.feature = feature
        self.handleDismiss = handleDismiss
    }
    
    var body: some View {
        // header
        VStack(alignment: .leading) {
            HStack {
                Text(place?.name ?? feature?.feature?.title ?? "unknown place")
                    .font(.title)
                    .fontWeight(.bold)
                
                Spacer()
                
                Button {
                    handleDismiss()
                } label: {
                    Image(systemName: "xmark")
                }
                .buttonStyle(.glass)
            }
            
            if (self.place != nil) {
                MapItemSelectionDetailsSheetPlaceActions(place: place!)
            } else if (feature != nil && feature!.feature != nil) {
                MapItemSelectionDetailsSheetFeatureActions(feature: feature!.feature!)
            } else {
                Text("you're seeing this because a condition didn't pass to give you any actions based on your selection")
            }
            
            Spacer()
        }
    }
}

private struct MapItemSelectionDetailsSheetPlaceActions: View {
    
    var place: Place
    
    var body: some View {
        NavigationLink {
            VisitEditor(place: place)
        } label: {
            Text("log a visit")
                .frame(maxWidth: .infinity)
            
        }
        .buttonStyle(.glassProminent)
        .controlSize(.large)
    }
}

private struct MapItemSelectionDetailsSheetFeatureActions: View {
    
    var feature: MapFeature
    
    var body: some View {
        NavigationLink {
            PlaceEditor(mapFeature: feature)
        } label: {
            Text("add to places")
                .frame(maxWidth: .infinity)
            
        }
        .buttonStyle(.glassProminent)
        .controlSize(.large)
    }
}

struct MapView: View {
    
    @Query var places: [Place]
    
    @State private var userLocation: CLLocation?
    
    @Environment(LocationManager.self) var locationManager: LocationManager
    
    @State private var selectedPlace: Place? = nil
    
    @State private var selection: MapSelection<MKMapItem>? = nil
    @State private var cameraPosition: MapCameraPosition = .automatic
    
    var body: some View {
        Map(position: $cameraPosition, selection: $selection) {
            ForEach(places) { place in
                Marker(place.name, coordinate: CLLocationCoordinate2DMake(place.lat, place.lon))
                    .tag(MapSelection(
                        MKMapItem(
                            location: CLLocation(latitude: place.lat, longitude: place.lon),
                            address: MKAddress(fullAddress: place.address, shortAddress: ""))),
                    )
            }
            
            UserAnnotation(anchor: .center)
        }
        .mapControls {
            MapUserLocationButton()
            MapCompass()
        }
        .mapStyle(.standard(pointsOfInterest: .all))
        .mapFeatureSelectionDisabled { feature in
            feature.kind != MapFeature.FeatureKind.pointOfInterest
        }
        //        .mapFeatureSelectionAccessory(.callout)
        .onAppear {
            locationManager.manager.requestLocation()
            userLocation = locationManager.manager.location
        }
        .onChange(of: selection) {
            selectedPlace = places.first(where: { $0.lat == selection?.value?.location.coordinate.latitude && $0.lon == selection?.value?.location.coordinate.longitude })
        }
        .sheet(
            isPresented: Binding<Bool>(
                get: { selection?.feature != nil || selection?.value != nil },
                set: { if !$0 {
                    selection = nil
                    selectedPlace = nil
                } }
            )
        ) {
            NavigationStack {
                MapItemSelectionDetailsSheet(place: selectedPlace, feature: selection) {
                    selection = nil
                    selectedPlace = nil
                }
            }
            .padding([.top, .leading, .trailing], 20)
            .presentationDetents([ .height(400) ])
        }
    }
}

#Preview {
    let modelContainer = try! ModelContainer.sample()
    let locationManager: LocationManager = LocationManager(modelContext: modelContainer.mainContext)
    
    MapView()
        .modelContainer(modelContainer)
        .environment(locationManager)}
