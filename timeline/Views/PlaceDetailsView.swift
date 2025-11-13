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
        
        _visits = Query(filter: #Predicate<Visit> { visit in
            visit.place.id == place.id
        }, sort: \.place.name)
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(place.name)
                .font(.title)
            Text(place.address)
                .font(.subheadline)
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
