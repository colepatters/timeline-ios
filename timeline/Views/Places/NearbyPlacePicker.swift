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
    
    var locationManager: LocationManager
    @State private var searchSource: NearbyPlacesSearchSource? = nil
    
    @State private var presentErrorModal: Bool = false
    @State private var errorAlertMessage: String = "Default message"
    
    var body: some View {
        NavigationStack {
            if searchSource == nil {
                VStack {
                    Text("Waiting for searchSource")
                    ProgressView()
                }
                
            }
            
            if searchSource != nil {
                if searchSource!.isSearching {
                    VStack {
                        Text("Grabbing nearby places")
                        ProgressView()
                    }
                }
            }
        }
        .onAppear {
            searchSource = NearbyPlacesSearchSource(manager: locationManager.manager)
            Task {
                do {
                    try await searchSource!.search()
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
