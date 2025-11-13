//
//  SearchDataSource.swift
//  timeline
//
//  Created by Cole Patterson on 10/4/25.
//

import Foundation
import MapKit
import OSLog

@MainActor
class SearchDataSource {
    private var currentSearch: MKLocalSearch?
    
    private let searchLogging = Logger(subsystem: Bundle.main.bundleIdentifier!, category: "Search Completions")
    
    func search(for queryString: String) async -> [MKMapItem] {
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = queryString
        return await performSearch(request)
    }
    
    private func performSearch(_ request: MKLocalSearch.Request) async -> [MKMapItem] {
        currentSearch?.cancel()
            
        request.region = MKCoordinateRegion(MKMapRect.world)
        
        let search = MKLocalSearch(request: request)
        currentSearch = search
        defer {
            currentSearch = nil
        }
        
        var results: [MKMapItem]
        
        do {
            let response = try await search.start()
            results = response.mapItems
        } catch let error {
            searchLogging.error("Search error: \(error.localizedDescription)")
            results = []
        }
        
        return results
    }
}
