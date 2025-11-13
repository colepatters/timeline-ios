//
//  dataExportHelper.swift
//  timeline
//
//  Created by Cole Patterson on 10/19/25.
//

import Foundation

class DataExport: Codable {
    private static let version: Int = 1
    public var places: [Place] = []
    public var visits: [Visit] = []
    public var locationSnapshots: [LocationSnapshot] = []
    
    public func toJSONString() throws -> String {
        let encoder = JSONEncoder()
        let data = try encoder.encode(self)
        return String(data: data, encoding: .utf8) ?? "Unable to convert data to string."
    }
}
