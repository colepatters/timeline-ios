//
//  VisitDetailsView.swift
//  timeline
//
//  Created by Cole Patterson on 11/18/25.
//

import SwiftUI
import SwiftData

struct VisitDetailsView: View {
    
    private var visit: Visit
    
    private var visitId: UUID
    @Query var uuidVisit: [ Visit ]

    init(visit: Visit) {
        self.visitId = visit.id
        self.visit = visit
    }
    
    var body: some View {
        NavigationStack {
            let activeVisit = visit ?? uuidVisit.first
            
            if (activeVisit == nil) {
                VStack(alignment: .leading) {
                    Text("Could not find a visit with this UUID.").fontWeight(.bold)
                    Text(visitId.uuidString).textSelection(.enabled)
                }
                .navigationTitle("Visit not found")
                .navigationSubtitle("Unknown datetime")
            } else {
                VStack(alignment: .leading) {
                }
                .toolbar {
                    ToolbarItem(placement: .confirmationAction) {
                        Menu {
                            NavigationLink {
                                PlaceDetailsView(place: activeVisit!.place)
                            } label: {
                                Label("Go to place", systemImage: "mappin.and.ellipse")
                            }
                            Button {
                                
                            } label: {
                                Label("Delete", systemImage: "trash")
                            }
                            .disabled(true)
                        } label: {
                            Image(systemName: "ellipsis")
                        }
                    }
                    ToolbarItem(placement: .automatic) {
                        NavigationLink {
                            VisitEditor(visit: visit)
                        } label: {
                            Image(systemName: "pencil")
                        }
                    }
                }
                .navigationTitle(activeVisit!.place.name)
                .navigationSubtitle(activeVisit!.timestamp.formatted())
            }
            
        }

        
    }
}

#Preview {
    VisitDetailsView(visit: sampleVisit)
//        .modelContainer(try! ModelContainer.sample())
}
