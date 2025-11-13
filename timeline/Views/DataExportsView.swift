//
//  DataExportsView.swift
//  timeline
//
//  Created by Cole Patterson on 10/16/25.
//

import SwiftUI
import SwiftData
import UniformTypeIdentifiers

struct DataExportsView: View {
    @Query var visits: [Visit]
    @Query var places: [Place]
    @Query var locationSnapshots: [LocationSnapshot]
    
    @State private var showFileExporter: Bool = false
    @State private var fileContent: String = "{}"
    
    @State private var showErrorAlert: Bool = false
    @State private var errorAlertText: String = "Default Message"
    
    // export all
    
    // export visits
    @State private var visitExportIncludePlaces: Bool = true
    
    private func handleError(message: String) {
        errorAlertText = message
        showErrorAlert = true
    }
    
    private func handleExportVisits() {
        if (visits.isEmpty) {
            errorAlertText = "There are no visits to export!"
            showErrorAlert = true
            return
        }
        
        let data = try? JSONEncoder().encode(visits)
        
        if (data == nil) {
            handleError(message: "JSON Encoder returned nil")
            return
        }
        
        fileContent = String(data: data!, encoding: .utf8)!
        showFileExporter = true
    }
    
    private func handleExportPlaces() {
        if (places.isEmpty) {
            errorAlertText = "There are no places to export!"
            showErrorAlert = true
            return
        }
        
        let data = try? JSONEncoder().encode(places)
        
        if (data == nil) {
            handleError(message: "JSON Encoder returned nil")
            return
        }
        
        fileContent = String(data: data!, encoding: .utf8)!
        showFileExporter = true
    }
    
    private func handleExportAll() {
        let export = DataExport()
        export.visits = visits
        export.places = places
        export.locationSnapshots = locationSnapshots
        
        do {
            fileContent = try export.toJSONString()
            showFileExporter = true
        } catch {
            handleError(message: error.localizedDescription)
        }
        
        
    }
    
    private func handleFileExportCompletion(_:Result<URL, any Error>) {
        print("file export completed")
        showFileExporter = false
        fileContent = "{}"
    }
    
    var body: some View {
        NavigationStack {
            List {
                Section("Export Visits") {
                    Toggle(isOn: $visitExportIncludePlaces) {
                        Text("Include full place data")
                        Text("By default, the place field only references by ID").font(.subheadline)
                    }
                    .disabled(true)
                    
                    Button {
                        handleExportVisits()
                    } label: {
                        Text("Export Visits")
                    }
                }
                
                Section("Export Places") {
                    Button {
                        
                    } label: {
                        Text("Export Places")
                    }
                    .disabled(true)
                }
                
                Section("Export Location Snapshots") {
                    Button {
                        
                    } label: {
                        Text("Export Location Snapshots")
                    }
                    .disabled(true)
                }
                
                Section("Export All") {
                    Button {
                        handleExportAll()
                    } label: {
                        Text("Export All")
                    }
                }
            }
            .navigationTitle("Data Exports")
        }
        .alert(
            Text("Error"),
            isPresented: $showErrorAlert
        ) {
            Button("Okie dokie") { showErrorAlert = false }
        } message: {
            Text("\(errorAlertText)")
        }
        .fileExporter(isPresented: $showFileExporter, document: JsonFile(initialText: fileContent), contentType: UTType.json, defaultFilename: "data.json", onCompletion: handleFileExportCompletion)
    }
    
}

#Preview {
    DataExportsView()
}
