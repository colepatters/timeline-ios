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
    
    var locationManager: LocationManager
    @State private var presentErrorModal: Bool = false
    @State private var errorAlertMessage: String = "Default message"
    
    @State private var searching: Bool = false
    @State private var mapItems: [ MKMapItem ] = []
    
    var handleSelect: ((_ mapItem: MKMapItem) -> Void)?
    
    var body: some View {
        NavigationStack {
            if (searching) {
                VStack {
                    Text("Grabbing nearby places")
                    ProgressView()
                }
            }
            
            List(mapItems, id: \.hash) { result in
                Button {
                    if (handleSelect != nil) {
                        handleSelect!(result)
                        dismiss()
                    }
                } label: {
                    VStack(alignment: .leading) {
                        Text(result.name ?? "no name")
                        Text(result.address?.fullAddress ?? "")
                            .font(.subheadline)
                    }
                }
            }
            
        }
        .onAppear {
            Task {
                do {
                    searching = true
                    
                    let request = MKLocalPointsOfInterestRequest(
                        center: locationManager.manager.location!.coordinate,
                        radius: 100
                    )
                    let result = try await MKLocalSearch(request: request).start()
                    
                    mapItems = result.mapItems
                    
                    searching = false
                } catch {
                    presentErrorModal = true
                    errorAlertMessage = String(describing: error)
                    print(error)
                }
            }
        }
        .alert(
            "Oops! An error occurred",
            isPresented: $presentErrorModal,
            presenting: errorAlertMessage
        ) { message in
            
        } message: { message in
            Text(message)
        }
        
    }
}

#Preview {
    let modelContainer = try! ModelContainer.sample()
    let locationManager: LocationManager = LocationManager(modelContext: modelContainer.mainContext)
    
    NearbyPlacePicker(locationManager: locationManager)
        .modelContainer(modelContainer)
}
