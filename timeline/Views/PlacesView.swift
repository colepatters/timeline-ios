//
//  PlacesView.swift
//  timeline
//
//  Created by Cole Patterson on 9/13/25.
//

import SwiftUI
import SwiftData

func handleNewPlace() {}

func filteredPlaces(places: [Place], searchText: String) -> [Place] {
    guard !searchText.isEmpty else { return places }
    return places.filter { place in
        place.name.lowercased().contains(searchText.lowercased()) || place.name.lowercased().contains(searchText.lowercased()) ||
        place.address.lowercased().contains(searchText.lowercased())
    }
}

struct PlacesView: View {
    @Query(sort: \Place.name) private var places: [Place]
    @State private var selectedPlace: Place?
    @State private var searchQuery: String = ""
    
    var body: some View {
        NavigationStack {
            List(filteredPlaces(places: places, searchText: searchQuery), selection: $selectedPlace) { place in
                NavigationLink {
                    PlaceDetailsView(place: place)
                } label: {
                    VStack(alignment: .leading) {
                        Text(place.name).font(.headline)
                        Text(place.address).font(.subheadline)
                    }
                }
            }
            .navigationTitle("Places")
            .searchable(text: $searchQuery)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    NavigationLink("+") {
                        PlaceEditor()
                            .navigationBarBackButtonHidden(true)
                    }
                }
            }
        }
    }
}

#Preview {
    PlacesView()
        .modelContainer(try! ModelContainer.sample())
}
