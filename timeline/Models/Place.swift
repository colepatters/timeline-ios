//
//  Place.swift
//  timeline
//
//  Created by Cole Patterson on 10/4/25.
//

import Foundation
import SwiftData

struct PlaceDTO: Codable, Identifiable {
    var id: String
    var name: String
    var address: String
    var lat: Double
    var lon: Double
}
