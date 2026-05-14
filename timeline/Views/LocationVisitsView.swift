//
//  LocationVisitsView.swift
//  timeline
//
//  Created by Cole Patterson on 11/26/25.
//

import SwiftUI
import SwiftData

struct LocationVisitsView: View {
    @Query(sort: \LocationVisit.arrivalDate, order: .reverse) var visits: [LocationVisit]
    
    var body: some View {
        List(visits) { visit in
            VStack(alignment: .leading) {
                Text(visit.arrivalDate.formatted(date: .complete, time: .omitted)).font(.headline)
                Text("\(visit.arrivalDate.formatted(date: .omitted, time: .complete)) - \(visit.departureDate.formatted(date: .omitted, time: .complete))")
                Text("\(visit.lat), \(visit.lon)")
            }
        }
    }
}

#Preview {
    LocationVisitsView()
}
