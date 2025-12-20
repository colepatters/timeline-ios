//
//  Visit.swift
//  timeline
//
//  Created by Cole Patterson on 10/5/25.
//

import Foundation
import SwiftData

enum VisitFromDTOError: Error {
    case invalidUUID(uuidString: String)
    case placeNotFound(placeId: String)
}

struct VisitDTO: Codable, Identifiable {
    var id: String
    var placeId: String
    var timestamp: Date
}
