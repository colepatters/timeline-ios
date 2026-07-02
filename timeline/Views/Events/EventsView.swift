//
//  EventsView.swift
//  timeline
//
//  Created by Cole Patterson on 11/30/25.
//

import SwiftUI
import SwiftData

struct EventsView: View {
    @Query var events: [ Event ]
    
    var body: some View {
        List(events) { event in
            NavigationLink {} label: {
                VStack(alignment: .leading) {
                    Text(event.name)
                }
            }
        }
    }
}

#Preview {
    EventsView()
        .modelContainer(try! ModelContainer.sample())
}
