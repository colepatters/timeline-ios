//
//  VisitDetailsView.swift
//  timeline
//
//  Created by Cole Patterson on 11/18/25.
//

import SwiftUI
import SwiftData

struct VisitDetailsView: View {
    let visit: Visit
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading) {
            }
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Menu {
                        NavigationLink {
                            PlaceDetailsView(place: visit.place)
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
            .navigationTitle(visit.place.name)
            .navigationSubtitle(visit.timestamp.formatted())
        }

        
    }
}

#Preview {
    VisitDetailsView(visit: sampleVisit)
//        .modelContainer(try! ModelContainer.sample())
}
