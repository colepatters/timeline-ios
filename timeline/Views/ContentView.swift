//
//  ContentView.swift
//  timeline
//
//  Created by Cole Patterson on 9/12/25.
//

import SwiftUI
import SwiftData

enum Tabs: Equatable, Hashable {
    case home
    case places
    case settings
    case history
    case events
    case map
}

struct ContentView: View {
    @Environment(AppContext.self) private var appContext
    @State private var selectedTab: Tabs = .home
    
    var body: some View {
        TabView(selection: $selectedTab) {
            Tab("Home", systemImage: "house", value: .home) {
                HomeView()
            }
            Tab("Places", systemImage: "pin", value: .places) {
                PlacesView()  
            }
            Tab("History", systemImage: "clock", value: .history) {
                HistoryView()
            }
            Tab("Map", systemImage: "map", value: .map) {
                MapView()
            }
            Tab("Settings", systemImage: "gear", value: .settings) {
                NavigationView {
                    SettingsView()
                        .navigationTitle("Settings")
                }
            }
        }
        .tabViewStyle(.sidebarAdaptable)
    }
}

#Preview(traits: .modifier(SampleAppContext())) {
    ContentView()
}
