//
//  SettingsView.swift
//  timeline
//
//  Created by Cole Patterson on 9/14/25.
//

import SwiftUI
import SwiftData
import UniformTypeIdentifiers

struct SettingsView: View {
    @State private var locationServiceActive = false
    @State private var monitorLocatioChanges = false
    
    @State private var pendingLocationServiceChange = false
    
    @Environment(LocationService.self) private var locationService
    
    private func handleLocationServiceToggle(newValue: Bool) -> Void {
        pendingLocationServiceChange = true
        
        if (newValue == true) {
            locationService.requestLocation()
        }
    }
    
    var body: some View {
        List {
            Section(header: Text("Force Updates")) {
                Button("Force location update") {
                    
                }
                .disabled(true)
            }
            Section(header: Text("Abilities")) {
                Toggle(isOn: $locationServiceActive) {
                    HStack() {
                        Text("Location Service")
                        if pendingLocationServiceChange {
                            ProgressView()
                        }
                    }
                }
                .disabled(true)
                .disabled(pendingLocationServiceChange)
                .onChange(of: locationServiceActive) { oldValue, newValue in
                    handleLocationServiceToggle(newValue: newValue)
                }
                Toggle(isOn: $monitorLocatioChanges) {
                    Text("Monitor Location Changes")
                }
                .disabled(true)
            }
            Section(header: Text("Other Settings")) {
                NavigationLink {
                    DataImportsView()
                } label: {
                    Text("Data Imports")
                }
                NavigationLink {
                    DataExportsView()
                } label: {
                    Text("Data Exports")
                }
            }
        }
        
    }
}

#Preview {
    SettingsView()
        .environment(LocationService())
}
