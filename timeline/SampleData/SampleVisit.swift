//
//  SampleData+Visit.swift
//  timeline
//
//  Created by Cole Patterson on 10/5/25.
//

import Foundation

let sampleVisit: Visit = Visit(id: nil, place: samplePlace, timestamp: Date.now)

var sampleVisits: [Visit] = [
    Visit(id: nil, place: samplePlaces[0], timestamp: Date.now),
    sampleVisit
]
