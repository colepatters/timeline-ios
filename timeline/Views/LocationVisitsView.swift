//
//  LocationVisitsView.swift
//  timeline
//
//  Created by Cole Patterson on 11/26/25.
//

import SwiftUI
import SwiftData
import MapKit

struct LocationVisitsView: View {
    @Query(sort: \LocationVisit.arrivalDate, order: .reverse) var visits: [LocationVisit]
    
    @State private var selectedVisit: LocationVisit? = nil
    
    var body: some View {
        List(visits) { visit in
            Button {
                selectedVisit = visit
            } label: {
                VStack(alignment: .leading) {
                    Text(visit.arrivalDate.formatted(date: .complete, time: .omitted)).font(.headline)
                    
                    Text("\(visit.arrivalDate.formatted(date: .omitted, time: .complete)) - \(visit.departureDate == Date.distantFuture ? "????" :  visit.departureDate.formatted(date: .omitted, time: .complete))")
                    Text("\(visit.lat), \(visit.lon)")
                }
            }
        }
        .sheet(
            isPresented:
                Binding<Bool>(
                    get: { selectedVisit != nil },
                    set: { if !$0 { selectedVisit = nil } }
                )
        ) {
            VStack(alignment: .leading) {
                
                HStack {
                    Text("CLVisit details")
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    Spacer()
                }
                
                if (selectedVisit == nil) {
                    Text("no visit selected, should be unreachable")
                } else {
                    VStack(alignment: .leading) {
                        Text("arrival")
                            .fontWeight(.bold)
                        Text(selectedVisit!.arrivalDate.formatted())
                    }
                    
                    if (selectedVisit!.departureDate != Date.distantFuture) {
                        VStack(alignment: .leading) {
                            Text("departure")
                                .fontWeight(.bold)
                            
                            Text(selectedVisit!.departureDate.formatted())
                        }
                    }
                    
                    Map(initialPosition: .automatic, bounds: MapCameraBounds(minimumDistance: 200)) {
                        Marker("", coordinate: CLLocationCoordinate2D(latitude: selectedVisit!.lat, longitude: selectedVisit!.lon))
                    }
                    .frame(height: 400)
                    
                    VStack {
                        Text("\(selectedVisit!.lat), \(selectedVisit!.lon)")
                    }
                    
                    Text("nearby places")
                        .padding(.top, 10)
                        .font(.title3)
                        .fontWeight(.bold)
                    
                    VStack {
                        ProgressView()
                    }
                    
                }
                
                
                Spacer()
            }
            .padding(20)
        }
    }
}

#Preview {
    let modelContainer = try! ModelContainer.sample()
    
    NavigationStack {
        LocationVisitsView()
            .modelContainer(modelContainer)
    }
    
}
