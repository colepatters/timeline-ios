//
//  MapsSearch.swift
//  timeline
//
//  Created by Cole Patterson on 10/4/25.
//

import SwiftUI
import MapKit

struct MapsSearch: View {
    @State private var searchQuery: String = ""
    @State private var searchResults: [MKMapItem] = []
    @State private var isSearching: Bool = false
    
    @Environment(\.dismiss) private var dismiss
    
    var handleMapItemSelection: ((_ mapItem: MKMapItem) -> Void)?
    
    var body: some View {
        NavigationStack {
            List(searchResults, id: \.hash) { result in
                Button {
                    if (handleMapItemSelection != nil) { handleMapItemSelection!(result) }
                    dismiss()
                } label: {
                    VStack(alignment: .leading) {
                        Text(result.name!).font(.headline)
                        Text(result.address!.fullAddress).font(.subheadline)
                    }
                }
                
            }
            .searchable(text: $searchQuery, placement: .toolbar)
            .onSubmit(of: .search) {
                Task {
                    isSearching = true
                    let searchSource = SearchDataSource()
                    searchResults = await searchSource.search(for: searchQuery)
                    isSearching = false
                }
            }
        }
        .fullScreenCover(isPresented: $isSearching) {
            ProgressView()
            Text("Loading...")
        }
    }
}

#Preview {
    MapsSearch()
}
