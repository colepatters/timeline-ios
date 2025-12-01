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
    @State private var fileName: String = "data"
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
        
        let dtos = visits.map { $0.toDTO() }
        
        guard let data = try? getJSONEncoder().encode(dtos) else {
            handleError(message: "JSON Encoder returned nil")
            return
        }
        
        fileName = "visits"
        fileContent = String(data: data, encoding: .utf8)!
        showFileExporter = true
    }
    
    private func handleExportPlaces() {
        if (places.isEmpty) {
            errorAlertText = "There are no places to export!"
            showErrorAlert = true
            return
        }
        
        let dtos = places.map { $0.toDTO() }
        
        guard let data = try? getJSONEncoder().encode(dtos) else {
            handleError(message: "JSON Encoder returned nil")
            return
        }
        
        fileName = "places"
        fileContent = String(data: data, encoding: .utf8)!
        showFileExporter = true
    }
    
    private func handleFileExportCompletion(_:Result<URL, any Error>) {
        print("file export completed")
        showFileExporter = false
        fileContent = "{}"
    }
    
    var body: some View {
            List {
                Section("Export Visits") {
                    Button {
                        handleExportVisits()
                    } label: {
                        Text("Export Visits")
                    }
                }
                
                Section("Export Places") {
                    Button {
                        handleExportPlaces()
                    } label: {
                        Text("Export Places")
                    }
                }
                
                Section("Export Location Snapshots") {
                    Button {
                        
                    } label: {
                        Text("Export Location Snapshots")
                    }
                    .disabled(true)
                }
            }
            .navigationTitle("Data Exports")
            .alert(
                Text("Error"),
                isPresented: $showErrorAlert
        ) {
            Button("Okie dokie") { showErrorAlert = false }
        } message: {
            Text("\(errorAlertText)")
        }
        .fileExporter(isPresented: $showFileExporter, document: JsonFile(initialText: fileContent), contentType: UTType.json, defaultFilename: "\(fileName).json", onCompletion: handleFileExportCompletion)
    }
    
}

#Preview {
    DataExportsView()
}
