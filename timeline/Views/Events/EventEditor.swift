//
//  EventEditor.swift
//  timeline
//
//  Created by Cole Patterson on 12/8/25.
//

import SwiftUI

struct EventEditor: View {
    
    @State var event: Event = Event(name: "")

    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Event")) {
                    TextField("Name", text: $event.name)
                }
            }
        }
    }
}

#Preview {
    EventEditor()
}
