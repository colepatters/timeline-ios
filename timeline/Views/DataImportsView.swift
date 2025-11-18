//
//  DataImportsView.swift
//  timeline
//
//  Created by Cole Patterson on 11/13/25.
//

import SwiftUI
import SwiftData
import UniformTypeIdentifiers

enum ImportType {
    case places
    case visits
}

private func handleImportPlaces(_ data: Data, in context: ModelContext) throws -> Void {
    let placeDTOs = try getJSONDecoder().decode([PlaceDTO].self, from: data)
    let places: [Place] = placeDTOs.compactMap {
        guard let placeUUID = UUID(uuidString: $0.id) else { return nil }
        return Place(id: placeUUID, name: $0.name, address: $0.address, lat: $0.lat, lon: $0.lon)
    }
    
    for place in places {
        context.insert(place)
    }
}

private func handleImportVisits(_ data: Data, in context: ModelContext) throws -> Void {
    let visitDTOs = try getJSONDecoder().decode([VisitDTO].self, from: data)
    
    let visits: [Visit] = try visitDTOs.compactMap { dto in
        guard let visitUUID = UUID(uuidString: dto.id),
              let placeUUID = UUID(uuidString: dto.placeId) else {
            return nil
        }
        
        // Fetch the Place in the SAME context and unwrap it
        var fetch = FetchDescriptor<Place>(predicate: #Predicate { $0.id == placeUUID })
        fetch.fetchLimit = 1
        guard let place = try context.fetch(fetch).first else {
            print("skipping import of visit: place not found")
            return nil
        }
        
        return Visit(id: visitUUID, place: place, timestamp: dto.timestamp)
    }
    
    for visit in visits {
        context.insert(visit)
    }
}

struct DataImportsView: View {
    @State private var loading: Bool = false
    
    @State var destroyBeforeImportAll: Bool = true
    @State var showFileImporter: Bool = false
    
    @State var currentImportType: ImportType? = nil
    
    @Environment(\.modelContext) private var modelContext
    
    var body: some View {
        List {
            Section("Places") {
                Button {
                    currentImportType = .places
                    showFileImporter = true
                } label: {
                    Text("Import Places")
                }
            }
            Section("Visits") {
                Button {
                    currentImportType = .visits
                    showFileImporter = true
                } label: {
                    Text("Import Visits")
                }
            }
        }
        .fileImporter(isPresented: $showFileImporter, allowedContentTypes: [UTType.json], onCompletion: handleFileLoadCompletion)
        .sheet(isPresented: $loading) {
            VStack {
                ProgressView()
                Text("Loading...")
            }
        }
    }
    
    private func handleFileLoadCompletion(_ result: Result<URL, any Error>) -> Void {
        loading = true
        
        switch result {
        case .success(let url):
            do {
                let gotAccess = url.startAccessingSecurityScopedResource()
                print("gotAccess=\(gotAccess)")
                let file = try FileHandle(forReadingFrom: url)
                guard let data = try file.readToEnd() else {
                    print("data = nil")
                    break
                }
                url.stopAccessingSecurityScopedResource()
                
                switch(currentImportType) {
                case .places:
                    try handleImportPlaces(data, in: modelContext)
                case .visits:
                    try handleImportVisits(data, in: modelContext)
                case nil:
                    print("no import type")
                }
                
            } catch {
                print(error)
            }
        case .failure(let error):
            print("failed before reading file")
            print(error)
        }
        
        loading = false
    }
}

#Preview {
    DataImportsView()
}
