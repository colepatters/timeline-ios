//
//  MapsSearch.swift
//  timeline
//
//  Created by Cole Patterson on 10/4/25.
//

import SwiftUI
import MapKit
import SwiftData
import OSLog

private enum SearchCoordinateType {
    case userLocation
    case suggestedCoordinate
    case manual
}

private enum SearchError: Error {
    case deviceLocationNotAvailable
}

struct MapsSearch: View {
    @Environment(AppContext.self) private var appContext
    @Environment(\.dismiss) private var dismiss
    
    @Query private var places: [ Place ]
    
    @State private var searchQuery: String = ""
    @State private var searchResults: [MKMapItem] = []
    @State private var isSearching: Bool = false
    
    @State private var searchCoordinateType: SearchCoordinateType = .manual
    @State private var manualSearchCoordinate = CLLocationCoordinate2D(latitude: 0, longitude: 0)
    private var suggestedCoordinate: CLLocationCoordinate2D? = nil
    private var suggestedCoordinateLabel: String = ""
    
    @State private var showManualCoordinateSelectionSheet: Bool = false
    
    var handleMapItemSelection: ((_ mapItem: MKMapItem) -> Void)? = nil
    
    init() {}
    
    init(handleSelection: @escaping (_: MKMapItem) -> Void) {
        self.handleMapItemSelection = handleSelection
    }
    
    init(suggestedCoordinateLabel: String, suggestedCoordinate: CLLocationCoordinate2D, handleSelection: @escaping (_: MKMapItem) -> Void) {
        self.suggestedCoordinateLabel = suggestedCoordinateLabel
        self.suggestedCoordinate = suggestedCoordinate
        self.handleMapItemSelection = handleSelection
    }
    
    private func placeExists(mapItem: MKMapItem) -> Bool {
        return places.filter { place in
            mapItem.location.coordinate.latitude == place.lat && mapItem.location.coordinate.longitude == place.lon
        }.count > 0
    }
    
    private func performSearch() async {
        do {
            searchResults = []
            
            isSearching = true
            
            if (searchCoordinateType == .userLocation && appContext.locationManager.manager.location == nil) {
                throw SearchError.deviceLocationNotAvailable
            }
            
            let request = MKLocalSearch.Request()
            request.naturalLanguageQuery = searchQuery
            
            request.region = MKCoordinateRegion(MKMapRect.world)
            
            switch searchCoordinateType {
            case .userLocation:
                request.region = MKCoordinateRegion(
                    MKMapRect(
                        origin: MKMapPoint(appContext.locationManager.manager.location!.coordinate),
                        size: .init(width: 500, height: 500)
                    )
                )
            case .suggestedCoordinate:
                request.region = MKCoordinateRegion(
                    MKMapRect(
                        origin: MKMapPoint(suggestedCoordinate!),
                        size: .init(width: 500, height: 500)
                    )
                )
            case .manual:
                request.region = MKCoordinateRegion(
                    MKMapRect(
                        origin: MKMapPoint(manualSearchCoordinate),
                        size: .init(width: 500, height: 500)
                    )
                )
            }
            
            let search = MKLocalSearch(request: request)
            let response = try await search.start()
            searchResults = response.mapItems
            
            isSearching = false
        } catch {
            isSearching = false
        }
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                VStack(alignment: .leading) {
                    Text("prioritize places near")
                    Picker(selection: $searchCoordinateType) {
                        Text("your location")
                            .tag(SearchCoordinateType.userLocation)
                            .selectionDisabled(appContext.locationManager.manager.location == nil)
                        
                        if (suggestedCoordinate != nil) {
                            Text("suggested")
                                .tag(SearchCoordinateType.suggestedCoordinate)
                        }
                        
                        Text("other")
                            .tag(SearchCoordinateType.manual)
                    } label: { }
                    .pickerStyle(.segmented)
                    .onChange(of: searchCoordinateType) { oldValue, newValue in
                        if (newValue == .manual) {
                            showManualCoordinateSelectionSheet = true
                        }
                        
                        if (searchQuery != "") {
                            Task {
                                await performSearch()
                            }
                        }
                    }
                }
                .padding()
                
                if (isSearching) {
                    Spacer()
                    
                    ProgressView()
                    
                    Spacer()
                }
                
                if (isSearching == false && searchResults.count == 0) {
                    Spacer()
                    
                    Text("ヽ(。_°)ノ")
                    
                    Spacer()
                } else {
                    List(searchResults, id: \.hash) { result in
                        Button {
                            if (handleMapItemSelection != nil) { handleMapItemSelection!(result) }
                            dismiss()
                        } label: {
                            VStack(alignment: .leading) {
                                Text(result.name!).font(.headline)
                                Text(result.address!.fullAddress).font(.subheadline)
                                
                                if (placeExists(mapItem: result)) {
                                    Text("⚠︎ a place already exists at this coordinate")
                                        .font(.footnote)
                                }
                            }
                        }
                    }
                    .listStyle(.plain)
                    .refreshable {
                        await performSearch()
                    }
                }
            }
            .searchable(text: $searchQuery, placement: .toolbar)
            .onSubmit(of: .search) {
                Task {
                    await performSearch()
                }
            }
        }
        .sheet(isPresented: $showManualCoordinateSelectionSheet) {
            Text("this sheet should show a map that a user can select a coordinate with")
            Button {
                showManualCoordinateSelectionSheet = false
            } label: {
                Text("dismiss")
            }
        }
    }
}


#Preview(traits: .modifier(SampleAppContext())) {
    MapsSearch()
}
