//
//  HistoryView.swift
//  timeline
//
//  Created by Cole Patterson on 10/4/25.
//

import SwiftUI
import SwiftData

struct HistoryView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \LocationSnapshot.timestamp, order: .forward) var allSnapshots: [LocationSnapshot]
    @Query(sort: \Visit.timestamp, order: .reverse) var visits: [Visit]
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(visits) { visit in
                    NavigationLink {
                        VisitDetailsView(visit: visit)
                    } label: {
                        VStack(alignment: .leading) {
                            Text(visit.timestamp.formatted()).font(.headline)
                            Text(visit.place.name).font(.subheadline)
                        }
                    }
                    
                }
            }
            .navigationTitle("History")
            .navigationSubtitle("\(visits.count) visits")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Menu {
                        NavigationLink("+ New Visit") {
                            VisitEditor(visit: nil)
                        }
                    } label: {
                        Text("+")
                    }
                }
            }
        }
    }
}

#Preview {
    HistoryView()
        .modelContainer(try! ModelContainer.sample())
}
