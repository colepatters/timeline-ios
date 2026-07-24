//
//  LogEntryView.swift
//  timeline
//
//  Created by Cole Patterson on 7/23/26.
//

import SwiftUI
import SwiftData

struct LogEntryView: View {
    @Query(sort: \LogEntry.createdAt, order: .reverse) var LogEntries: [ LogEntry ]
    
    var body: some View {
        List(LogEntries) { logEntry in
            VStack(alignment: .leading) {
                if (logEntry.title != nil) {
                    Text(logEntry.title!)
                        .font(.headline)
                }
                Text(logEntry.body)
                    .font(.subheadline)
                
                HStack {
                    switch logEntry.level {
                    case .info: Text("ℹ")
                    case .warn: Text("⚠")
                    case .error: Text("x")
                    case .fatal: Text("⏹")
                    }
                    Text("•")
                    Text(logEntry.createdAt.formatted())
                        .font(.footnote)
                }
            }
        }
        .listStyle(.plain)
    }
}

#Preview {
    let modelContainer = try! ModelContainer.sample()
    let locationManager: LocationManager = LocationManager(modelContext: modelContainer.mainContext)
    
    NavigationStack {
        LogEntryView()
            .modelContainer(modelContainer)
            .environment(locationManager)
    }
}
