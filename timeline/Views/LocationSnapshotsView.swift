//
//  LocationSnapshotsView.swift
//  timeline
//
//  Created by Cole Patterson on 11/19/25.
//

import SwiftUI
import SwiftData

struct LocationSnapshotsView: View {
    @Query(sort: \LocationSnapshot.timestamp, order: .reverse) var snapshots: [LocationSnapshot]
    
    var body: some View {
        List(snapshots) { snapshot in
            VStack(alignment: .leading) {
                Text(snapshot.timestamp.formatted())
                    .bold()
                    .font(.headline)
                Text("\(snapshot.lat), \(snapshot.lon)")
            }
        }
    }
}

#Preview {
    LocationSnapshotsView()
        .modelContainer(try! ModelContainer.sample())
}
