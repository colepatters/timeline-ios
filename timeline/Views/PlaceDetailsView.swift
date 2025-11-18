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
            sort: \.place.name
        )
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(place.name)
                .font(.title)
            Text(place.id.uuidString)
                .textSelection(.enabled)
            Text(place.address)
                .font(.subheadline)
                .textSelection(.enabled)
            Text("\(visits.count) Visits")
            List(visits) { visit in
                VStack {
                    Text(visit.timestamp.formatted())
                }
            }
            .listStyle(.plain)
        }
        .padding()
    }
}

#Preview {
    PlaceDetailsView(place: samplePlace)
        .modelContainer(try! ModelContainer.sample())
}

