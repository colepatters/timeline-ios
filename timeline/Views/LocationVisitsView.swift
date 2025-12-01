//
//  LocationVisitsView.swift
//  timeline
//
//  Created by Cole Patterson on 11/26/25.
//

import SwiftUI
import SwiftData

struct LocationVisitsView: View {
    @Query var visits: [LocationVisit]
    
    var body: some View {
        List(visits) { visit in
            VStack {
                Text("\(visit.arrivalDate.formatted()) - \(visit.arrivalDate.formatted())")
                    .font(.headline)
                Text("\(visit.lat), \(visit.lon)")
            }
        }
    }
}

#Preview {
    LocationVisitsView()
}
