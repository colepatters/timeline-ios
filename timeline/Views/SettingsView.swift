//
//  SettingsView.swift
//  timeline
//
//  Created by Cole Patterson on 9/14/25.
//

import SwiftUI
import SwiftData
import UniformTypeIdentifiers
import MapKit

struct SettingsView: View {
    @State private var locationServiceActive = false
    @State private var allowBackgroundLocation = false
    
    @State private var pendingLocationServiceChange = false
    
    @Environment(LocationManager.self) var locationManager: LocationManager
    
    private func handleLocationServiceToggle(newValue: Bool) -> Void {
        pendingLocationServiceChange = true
        
        if (newValue == true) {
            locationManager.manager.requestAlwaysAuthorization()
        }
        
        pendingLocationServiceChange = false
    }
    
    private func handleBackgroundMonitoringToggle(newValue: Bool) -> Void {
        
        if newValue {
            // turn on background monitoring
            locationManager.manager.startUpdatingLocation()
            locationManager.manager.startMonitoringVisits()
        } else {
            // turn off background monitoring
            locationManager.manager.stopMonitoringVisits()
            locationManager.manager.stopMonitoringVisits()
        }
        
    }
    
    var body: some View {
        List {
            Section(header: Text("Location Services")) {
                Button("Force location update") {
                    locationManager.manager.requestLocation()
                }

                Toggle(isOn: $locationServiceActive) {
                    HStack() {
                        Text("Location Service")
                        if pendingLocationServiceChange {
                            ProgressView()
                        }
                    }
                }
                .disabled(pendingLocationServiceChange)
                .onChange(of: locationServiceActive) { oldValue, newValue in
                    handleLocationServiceToggle(newValue: newValue)
                }
                Toggle(isOn: $allowBackgroundLocation) {
                    Text("Background monitoring")
                }
                .onChange(of: allowBackgroundLocation) { oldValue, newValue in
                    handleBackgroundMonitoringToggle(newValue: newValue)
                }
                NavigationLink {
                    LocationSnapshotsView()
                        .navigationTitle("Location snapshots")
                } label: {
                    Text("View location snapshots")
                }
                NavigationLink {
                    LocationVisitsView()
                        .navigationTitle("Location visits")
                } label: {
                    Text("View visits")
                }
            }
            Section(header: Text("Other Settings")) {
                NavigationLink {
                    DataImportsView()
                } label: {
                    Text("Data Imports")
                }
                NavigationLink {
                    DataExportsView()
                        .navigationTitle("Data Exports")
                } label: {
                    Text("Data Exports")
                }
            }
        }
        .onAppear {
            pendingLocationServiceChange = true
            
            let locationAuthStatus = locationManager.manager.authorizationStatus
            switch(locationAuthStatus) {
            case .authorizedAlways:
                locationServiceActive = true
            default:
                locationServiceActive = false
            }
            
            
            
            pendingLocationServiceChange = false
        }
        
    }
}

#Preview {
    let modelContainer = try! ModelContainer.sample()
    let locationManager: LocationManager = LocationManager(modelContext: modelContainer.mainContext)
    
    SettingsView()
        .modelContainer(modelContainer)
        .environment(locationManager)
}
