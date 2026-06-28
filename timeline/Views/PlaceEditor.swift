//
//  NewPlaceView.swift
//  timeline
//
//  Created by Cole Patterson on 9/13/25.
//

import SwiftUI
import SwiftData
import MapKit

struct PlaceEditor: View {
    var place: Place? = nil
    
    @State private var placeName: String = ""
    @State private var placeNickname: String = ""
    @State private var placeAddress: String = ""
    @State private var placeLat: String = ""
    @State private var placeLon: String = ""
    
    @State private var loadingAddress: Bool = false
    
    private var mapFeature: MapFeature? = nil
    
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    @Environment(LocationManager.self) var locationManager: LocationManager
    
    init() {}
    
    init(place: Place) {
        self.place = place
    }
    
    init(mapItem: MKMapItem) {
        self.placeName = mapItem.name ?? mapItem.address?.fullAddress ?? "unknown place"
        self.placeAddress = mapItem.address?.fullAddress ?? ""
        self.placeLat = mapItem.location.coordinate.latitude.formatted()
        self.placeLon = mapItem.location.coordinate.longitude.formatted()
    }
    
    init(mapFeature: MapFeature) {
        self.mapFeature = mapFeature
        _placeName = State(initialValue: mapFeature.title ?? "")
        _placeLat = State(initialValue: String(mapFeature.coordinate.latitude))
        _placeLon = State(initialValue: String(mapFeature.coordinate.longitude))
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Place Info")) {
                    TextField("Name", text: $placeName)
                    TextField("Nickname (optional)", text: $placeNickname)
                        .disabled(true)
                    
                    if (loadingAddress) {
                        HStack {
                            ProgressView()
                            Text("loading address...")
                        }
                    } else {
                        TextField("Address", text: $placeAddress)
                            .disabled(loadingAddress)
                    }
                    
                    
                    TextField("Lat", text: $placeLat)
                        .keyboardType(.decimalPad)
                    TextField("Lon", text: $placeLon)
                        .keyboardType(.decimalPad)
                }
                
                Section(header: Text("Autofill Options")) {
                    NavigationLink("Search for a place") {
                        MapsSearch(handleMapItemSelection: handleMapItemSelection)
                            .navigationBarBackButtonHidden(false)
                    }
                    NavigationLink("Choose from places nearby") {
                        NearbyPlacePicker(locationManager: locationManager)
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        handleSave()
                    }
                }
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel", role: .cancel) {
                        dismiss()
                    }
                }
            }
        }
        .onAppear {
            if let place {
                self.placeName = place.name
    //            self.placeNickname = place.nickname
                self.placeAddress = place.address
                self.placeLat = String(place.lat)
                self.placeLon = String(place.lon)
            }
            
            if (self.mapFeature != nil) {
                Task {
                    loadingAddress = true
                    
                    if let request = MKReverseGeocodingRequest(location: CLLocation(latitude: mapFeature!.coordinate.latitude, longitude: mapFeature!.coordinate.longitude)) {
                       do {
                           let mapitems = try await request.mapItems
                           if let mapitem = mapitems.first {
                               self.placeAddress = mapitem.address?.fullAddress ?? ""
                           }
                       } catch let error {
                           print("error: \(error)")
                           loadingAddress = false
                       }
                   }
                    
                    loadingAddress = false
                }
            }
        }
    }
    
    func handleMapItemSelection(mapItem: MKMapItem) {
        placeName = mapItem.name ?? "Untitled Place"
        
        if (mapItem.address != nil) {
            placeAddress = mapItem.address!.fullAddress
        } else {
            placeAddress = "No address provided"
        }
        
        placeLat = mapItem.location.coordinate.latitude.formatted()
        placeLon = mapItem.location.coordinate.longitude.formatted()
    }
    
    func handleSave() {
        
        if let place {
            place.name = placeName
//            place.nickname = placeNickname
            place.address = placeAddress
            place.lat = Double(placeLat)!
            place.lon = Double(placeLon)!
        } else {
            let newPlace = Place(id: nil, name: placeName, address: placeAddress, lat: Double(placeLat)!, lon: Double(placeLon)!)
            modelContext.insert(newPlace)
        }
        
        dismiss()
    }
}

#Preview {
    let modelContainer = try! ModelContainer.sample()
    let locationManager: LocationManager = LocationManager(modelContext: modelContainer.mainContext)
    
    PlaceEditor()
        .modelContainer(modelContainer)
        .environment(locationManager)
}
