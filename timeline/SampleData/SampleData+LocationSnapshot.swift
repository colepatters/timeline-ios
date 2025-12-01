//
//  SampleData+LocationSnapshot.swift
//  timeline
//
//  Created by Cole Patterson on 10/4/25.
//

import Foundation

let sampleLocationSnapshots: [LocationSnapshot] = [
    LocationSnapshot(lat: 0.000000, lon: 0.00000, timestamp: Date.now, createdAt: Date.now, systemTags: []),
    LocationSnapshot(lat: 0.000000, lon: 0.00000, timestamp: Date.distantFuture, createdAt: Date.now, systemTags: []),
    LocationSnapshot(lat: 0.000000, lon: 0.00000, timestamp: Date.distantPast, createdAt: Date.now, systemTags: [])
]
