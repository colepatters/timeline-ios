//
//  VisitEditor.swift
//  timeline
//
//  Created by Cole Patterson on 10/5/25.
//

import SwiftUI
import SwiftData
import MapKit

struct VisitEditor: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    var visit: Visit? = nil
    
    @State var visitPlace: Place? = nil
    @State private var visitTimestamp: Date = Date.now
    
    private var mapItem: MKMapItem? = nil
    
    init() {}
    
    init(visit: Visit) {
        self.visit = visit
    }
    
    init(place: Place, timestamp: Date? = nil) {
        _visitPlace = State(initialValue: place)
        self.visitTimestamp = timestamp ?? Date.now
    }
    
    init(mapItem: MKMapItem, arrivalDate: Date) {
        self.mapItem = mapItem
        self.visitTimestamp = arrivalDate
    }
    
    var body: some View {
        NavigationStack {
            Form {
                NavigationLink {
                    PlacePicker(sortByDistance: true, externalSelectionHandler: handlePlaceSelection)
                } label: {
                    VStack(alignment: .leading) {
                        Text("Place").font(.headline)
                        if(visitPlace != nil) {
                            Text(visitPlace!.name)
                        } else {
                            Text("Make a selection")
                        }
                    }
                }
                DatePicker(selection: $visitTimestamp) {
                    HStack {
                        Image(systemName: "clock.fill")
                        Text("when?")
                    }
                }
                Button("Submit") {
                    handleSubmit()
                }
                .disabled(visitPlace == nil)
            }
            .scrollContentBackground(.hidden)
        }
        .onAppear {
            visitTimestamp = Date.now
            
            if let visit {
                visitTimestamp = visit.timestamp
                visitPlace = visit.place
            }
        }
    }
    
    func handlePlaceSelection(place: Place) {
        visitPlace = place
    }
    
    func handleSubmit() {
        if let visit {
            visit.place = visitPlace!
            visit.timestamp = visitTimestamp
        } else {
            let newVisit = Visit(id: nil, place: visitPlace!, timestamp: visitTimestamp)
            modelContext.insert(newVisit)
        }
        
        dismiss()
    }
    
    
}

#Preview("new visit") {
    VisitEditor()
        .modelContainer(try! ModelContainer.sample())
}

#Preview("edit existing visit") {
    
    let place = Place(id: nil, name: "Home", address: "16535 Tranquility Ct Se Prior Lake MN 55372", lat: 44.710309, lon: -93.434450)
    let visit = Visit(id: UUID(), place: place, timestamp: Date.now)
    
    VisitEditor(visit: visit)
        .modelContainer(try! ModelContainer.sample())
}
