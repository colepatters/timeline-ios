//
//  timelineTests.swift
//  timelineTests
//
//  Created by Cole Patterson on 9/12/25.
//

import SwiftData
import Foundation
import Testing
@testable import timeline

struct timelineTests {

    @Test func example() async throws {
        // Write your test here and use APIs like `#expect(...)` to check expected conditions.
    }
    
    @Test func test1() async throws {
        let container = Database().container
        let context = ModelContext(container)
        
        // insert new place
        context.insert(Place(id: nil, name: "Princess House", address: "123 St", lat: 0.000, lon: 0.000))
        
        let predicate: Predicate<Place> = #Predicate { $0.name == "Princess House" }
        let sortDescriptors: [SortDescriptor<Place>] = []
        
        // read place
        let fetchDescriptor = FetchDescriptor<Place>(
            predicate: predicate,
            sortBy: sortDescriptors
        )
        
        let result = try context.fetch(fetchDescriptor)
        print(result.count)
        
        #expect(result.isEmpty == false)
    }

}
