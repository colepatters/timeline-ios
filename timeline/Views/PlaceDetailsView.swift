//
//  PlaceDetailsView.swift
//  timeline
//
//  Created by Cole Patterson on 11/13/25.
//

import SwiftUI
import SwiftData

struct PlaceDetailsView: View {
    let place: Place
    
    @Query private var visits: [Visit]
    
    init(place: Place) {
        self.place = place
        let placeId = place.id
        _visits = Query(
            filter: #Predicate<Visit> { visit in
                visit.place.id == placeId
            },
            sort: \.timestamp,
            order: .reverse
        )
    }
    
    var body: some View {
        NavigationStack {
            List(visits) { visit in
                NavigationLink {
                    VisitDetailsView(visit: visit)
                } label: {
                    Text(visit.timestamp.formatted())
                }
            }
            .listStyle(.plain)
            .navigationTitle(place.name)
            .navigationSubtitle(place.address)
            .toolbar {
                NavigationLink {
                    PlaceEditor(place: place)
                } label: {
                    Image(systemName: "pencil")
                }
                Menu {
                    NavigationLink {
                        VisitEditor(visit: nil, visitPlace: place)
                    } label: {
                        Label("New visit", systemImage: "plus")
                    }
                    Button {}
                    label: {
                        Label("Delete", systemImage: "trash")
                    }
                    .disabled(true)
                } label: {
                    Image(systemName: "ellipsis")
                }
            }
        }
    }
}

#Preview {
    PlaceDetailsView(place: samplePlace)
        .modelContainer(try! ModelContainer.sample())
}

