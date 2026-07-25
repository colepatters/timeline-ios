//
//  HomeView.swift
//  timeline
//
//  Created by Cole Patterson on 10/5/25.
//

import SwiftUI
import SwiftData

struct HomeView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(LocationManager.self) var locationManager: LocationManager
    
    @State private var loggingQuickVisit: Bool = false
    
    var body: some View {
        NavigationStack {
            List {
                Section(header: Text("Adds")) {
                    NavigationLink {
                        VisitEditor()
                    } label: {
                        Text("+ New Visit")
                    }
                    NavigationLink {
                        PlaceEditor()
                    } label: {
                        Text("+ New Place")
                    }
                }
                
                Section(header: Text("Quick Visits")) {
                    Button {
                        loggingQuickVisit = true
                        locationManager.delegate.locationUpdateCallbackQueue.append { visit in
                            modelContext.insert(QuickVisit(
                                arrival: visit.timestamp,
                                source: .app,
                                lat: visit.coordinate.latitude,
                                lon: visit.coordinate.longitude
                            ))
                            loggingQuickVisit = false
                            }
                        locationManager.manager.requestLocation()
                    } label: {
                        HStack {
                            Text("+ Log quick visit")
                            
                            if (loggingQuickVisit) {
                                Spacer()
                                ProgressView()                                
                            }
                        }
                    }
                    .disabled(loggingQuickVisit)
                    
                    NavigationLink {
                        QuickVisitsView()
                    } label: {
                        Text("Review Quick Visits")
                    }
                }
                
                Button {
                    locationManager.manager.requestLocation()
                } label: {
                    Text("Force location update")
                }
            }
            .navigationTitle("Home")
        }
    }
}

#Preview {
    let modelContainer = try! ModelContainer.sample()
    let locationManager: LocationManager = LocationManager(modelContext: modelContainer.mainContext)
    
    NavigationStack {
        HomeView()
            .modelContainer(modelContainer)
            .environment(locationManager)
    }
}

