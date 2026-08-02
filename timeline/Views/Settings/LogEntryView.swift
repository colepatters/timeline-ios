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
                    case .info: Text("ℹ").font(.footnote)
                    case .warn: Text("⚠").font(.footnote)
                    case .error: Text("x").font(.footnote)
                    case .fatal: Text("⏹").font(.footnote)
                    }
                    Text("•").font(.footnote)
                    Text(logEntry.createdAt.formatted())
                        .font(.footnote)
                }
            }
        }
        .listStyle(.plain)
    }
}

#Preview(traits: .modifier(SampleAppContext())) {
    NavigationStack {
        LogEntryView()
    }
}
