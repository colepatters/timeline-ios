//
//  PlacePicker.swift
//  timeline
//
//  Created by Cole Patterson on 10/5/25.
//

import SwiftUI
import SwiftData

struct PlacePicker: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    @Query var places: [Place]
    
    @State private var searchQuery: String = ""
    
    var externalSelectionHandler: ((_ place: Place) -> Void)?
    
    var body: some View {
        List(filteredPlaces(places: places, searchText: searchQuery)) { place in
            Button {
                handleSelection(place: place)
            } label: {
                VStack(alignment: .leading) {
                    Text(place.name).font(.headline)
                    Text(place.address).font(.subheadline)
                }
            }
        }
        .searchable(text: $searchQuery)
    }
    
    func handleSelection(place: Place) {
        if (externalSelectionHandler != nil) {
            externalSelectionHandler!(place)
        }
        dismiss()
    }
}

#Preview {
    PlacePicker()
        .modelContainer(try! ModelContainer.sample())
}
