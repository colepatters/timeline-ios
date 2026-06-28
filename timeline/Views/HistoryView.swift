//
//  HistoryView.swift
//  timeline
//
//  Created by Cole Patterson on 10/4/25.
//

import SwiftUI
import SwiftData

func groupVisits(visits: [ Visit ]) -> Dictionary<Date, [ Visit ]> {
    return Dictionary(grouping: visits.sorted {
        return $0.timestamp > $1.timestamp
    }, by: { $0.timestamp.stripTime() })
}

struct HistoryView: View {
    @Environment(\.modelContext) private var modelContext
    
    @Query(sort: \Visit.timestamp, order: .reverse) var visits: [Visit]
    
    var body: some View {
        NavigationStack {
            List(groupVisits(visits: visits).sorted(by: {
                $0.key > $1.key
            }), id: \.key) { date, groupVisits in
                Section {
                    ForEach(groupVisits) { visit in
                        HistoryViewListEntry(visit: visit)
                    }
                } header: {
                    Text(date.formatted(date: .complete, time: .omitted))
                } footer: {
                    Text("\(groupVisits.count) visits")
                }
            }
            .navigationTitle("History")
            .navigationSubtitle("\(visits.count) visits")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Menu {
                        NavigationLink("+ New Visit") {
                            VisitEditor()
                        }
                    } label: {
                        Text("+")
                    }
                }
            }
        }
    }
}
    
struct HistoryViewListEntry: View {
    @State var visit: Visit
    
    var body: some View {
        NavigationLink {
            VisitDetailsView(visit: visit)
        } label: {
            HStack {
                Image(systemName: "mappin")
                
                VStack(alignment: .leading) {
                    Text(visit.place.name)
                        .font(.headline)
                    Text(visit.timestamp.formatted(date: .omitted, time: .shortened))
                        .font(.subheadline)
                }
            }
        }
    }
}

#Preview {
    HistoryView()
        .modelContainer(try! ModelContainer.sample())
}
