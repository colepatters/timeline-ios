//
//  HomeView.swift
//  timeline
//
//  Created by Cole Patterson on 10/5/25.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        NavigationStack {
            List {
                Section(header: Text("Adds")) {
                    NavigationLink {
                        VisitEditor(visit: nil)
                    } label: {
                        Text("+ New Visit")
                    }
                    NavigationLink {
                        PlaceEditor(place: nil)
                    } label: {
                        Text("+ New Place")
                    }
                }
            }
            .navigationTitle("Home")
        }
    }
}

#Preview {
    HomeView()
}
