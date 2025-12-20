//
//  HistoryViewListEntry.swift
//  timeline
//
//  Created by Cole Patterson on 12/11/25.
//

import SwiftUI

struct HistoryViewListEntry: View {
    @State var entry: HistoryEntry
    
    var body: some View {
        NavigationLink {
            if (entry.type == .visit) {
                VisitDetailsView(id: entry.objectId)
            }
        } label: {
            HStack {
                switch entry.type {
                    case .visit:
                        Image(systemName: "mappin")
                    case .snapshot:
                        Image(systemName: "location")
                    default:
                        Image(systemName: "questionmark")
                }
                
                VStack(alignment: .leading) {
                    if entry.title != nil {
                        Text(entry.title!).font(.headline)
                    }
                    if entry.subtitle != nil {
                        Text(entry.subtitle!).font(.subheadline)
                    }
                }
            }
        }
    }
}

#Preview {
    HistoryViewListEntry(entry: sampleHistoryEntry)
}
