//
//  QuickVisitsView.swift
//  timeline
//
//  Created by Cole Patterson on 7/25/26.
//

import SwiftUI
import SwiftData

struct QuickVisitsView: View {
    @Query private var quickVisits: [ QuickVisit ]
    
    var body: some View {
        List(quickVisits) { quickVisit in
            VStack(alignment: .leading) {
                if (quickVisit.departure == nil) {
                    Text(quickVisit.createdAt.formatted())
                } else {
                    Text("\(quickVisit.createdAt.formatted()), \(quickVisit.departure!.formatted())")
                }
                Text("\(quickVisit.lat), \(quickVisit.lon)")
                    .font(.subheadline)
            }
        }
    }
}

#Preview(traits: .modifier(SampleAppContext())) {
    QuickVisitsView()
}
