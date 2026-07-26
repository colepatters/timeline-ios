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
import UniformTypeIdentifiers


struct SettingsView: View {
    @State private var locationServiceActive = false
    @State private var allowBackgroundLocation = false
    
    @State private var pendingLocationServiceChange = false
    
    @State private var showFileExporter = false
    @State private var fileExportDocument = JsonFile(initialText: "default file")
    
    @Environment(LocationManager.self) var locationManager: LocationManager
    @Environment(\.modelContext) private var modelContext
    @Environment(ErrorAlertQueue.self) private var errorAlertQueue
    
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
            locationManager.manager.stopUpdatingLocation()
            locationManager.manager.stopMonitoringVisits()
        }
        
    }
    
    
    private func handleFileExportResult(_ result: Result<URL, any Error>) {
        if (type(of: result) == Error.self) {
            errorAlertQueue.append(ErrorAlert(title: "could not save file", message: (result as! any Error).localizedDescription))
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
                Button {
                    UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
                } label: {
                    HStack {
                        Image(systemName: "gear")
                        Text("open permissions in settings")
                    }
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
                
                Button {
                    do {
                        fileExportDocument = try allDataToJSON(modelContext: modelContext)
                        showFileExporter = true
                    } catch {
                        errorAlertQueue.append(ErrorAlert(title: "failed to encode data to json", message: error.localizedDescription))
                    }
                } label: {
                    HStack {
                        Image(systemName: "iphone.and.arrow.right.outward")
                        Text("Export all data")
                    }
                }
                
                NavigationLink {
                    LogEntryView()
                } label: {
                    Text("Logs")
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
        .fileExporter(
            isPresented: $showFileExporter,
            document: fileExportDocument,
            contentType: UTType.json,
            defaultFilename: "\(Date.now.formatted(date: .abbreviated, time: .omitted)).json",
            onCompletion: handleFileExportResult
        )
        
    }
}

#Preview {
    let modelContainer = try! ModelContainer.sample()
    let locationManager: LocationManager = LocationManager(modelContext: modelContainer.mainContext)
    let alertQueue = ErrorAlertQueue()
    
    NavigationStack {
        SettingsView()
            .modelContainer(modelContainer)
            .environment(locationManager)
            .environment(alertQueue)
    }
}
