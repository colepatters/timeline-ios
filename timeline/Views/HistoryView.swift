//
//  HistoryView.swift
//  timeline
//
//  Created by Cole Patterson on 10/4/25.
//

import SwiftUI
import SwiftData

enum HistoryEntryType {
    case visit
    case snapshot
    case eventOccurrence
}

struct HistoryEntry: Identifiable {
    var id: Int
    
    var type: HistoryEntryType
    
    var icon: String?
    
    var timestamp: Date
    var objectId: UUID
    
    var title: String?
    var subtitle: String?
}

@Observable
final class HistoryEntriesViewModel {
    var entries: [ HistoryEntry ] = []
    var includeLocationSnapshots: Bool = false
    
    func updateEntries(visits: [ Visit ]?, snapshots: [
        LocationSnapshot ]? ) -> Void {
            self.entries = []
        if (visits != nil) {
            for visit in visits! {
                entries.append(HistoryEntry(
                    id: entries.count,
                    type: .visit,
                    timestamp: visit.timestamp,
                    objectId: visit.id,
                    title: visit.place.name,
                    subtitle: visit.timestamp.formatted(date: .omitted, time: .shortened)
                ))
            }
        }
        if (snapshots != nil) {
            for snapshot in snapshots! {
                entries.append(HistoryEntry(
                    id: entries.count,
                    type: .snapshot,
                    timestamp: snapshot.timestamp,
                    objectId: UUID(),
                    subtitle: "\(snapshot.lat), \(snapshot.lon)"
                ))
            }
        }
    }
    
    func groupEntries() -> [Dictionary<Date, [HistoryEntry]>.Element] {
        
        let filteredEntries: [ HistoryEntry ] = self.entries.filter { entry in
            if self.includeLocationSnapshots == false && entry.type == .snapshot {
                return false
            } else {
                return true
            }
        }
        
        return Dictionary(grouping: filteredEntries.sorted {
            return $0.timestamp > $1.timestamp
        }, by: { $0.timestamp.stripTime() }).sorted {
            return $0.key > $1.key
        }
    }

}

struct HistoryView: View {
    @Environment(\.modelContext) private var modelContext
    
    @Query(sort: \LocationSnapshot.timestamp, order: .forward) var allSnapshots: [LocationSnapshot]
    @Query(sort: \Visit.timestamp, order: .reverse) var visits: [Visit]
    
    @State var entriesViewModel: HistoryEntriesViewModel = HistoryEntriesViewModel()
    
    var body: some View {
        NavigationStack {
            List {
                let entries = entriesViewModel.groupEntries()
                ForEach(entries, id: \.key) { date, entries in
                    Section {
                        ForEach(entries) { entry in
                            HistoryViewListEntry(entry: entry)
                        }
                    } header: {
                        Text(date.formatted(date: .complete, time: .omitted))
                    } footer: {
                        Text("\(entries.count) visits")
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
                ToolbarItem(placement: .secondaryAction) {
                    Menu("Filter") {
                        Toggle(
                            "Location Snapshots",
                            systemImage: "location",
                            isOn: $entriesViewModel.includeLocationSnapshots
                        )
                    }
                }
            }
            .onAppear {
                entriesViewModel.updateEntries(visits: visits, snapshots: allSnapshots)
            }
        }
    }
}

#Preview {
    HistoryView()
        .modelContainer(try! ModelContainer.sample())
}
