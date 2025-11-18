//
//  VisitEditor.swift
//  timeline
//
//  Created by Cole Patterson on 10/5/25.
//

import SwiftUI
import SwiftData

struct VisitEditor: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    let visit: Visit?
    
    @State var visitPlace: Place? = nil
    @State private var visitTimestamp: Date = Date.now
    
    var body: some View {
        NavigationStack {
            Form {
                NavigationLink {
                    PlacePicker(externalSelectionHandler: handlePlaceSelection)
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
                DatePicker("Visit Timestamp", selection: $visitTimestamp)
                Button("Submit") {
                    handleSubmit()
                }
                .disabled(visitPlace == nil)
            }
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

#Preview {
    VisitEditor(visit: nil)
        .modelContainer(try! ModelContainer.sample())
}
