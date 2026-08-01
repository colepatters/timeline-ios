//
//  LogEntry.swift
//  timeline
//
//  Created by Cole Patterson on 7/23/26.
//

import Foundation
import SwiftData

/*
 
 Check this out, I must've pulled this from claude or stack overflow at some point
 
 private let searchLogging = Logger(subsystem: Bundle.main.bundleIdentifier!, category: "Search Completions")
 
 I guess there's already a subsustem built in for logging (not surprising)
 
 */

enum LogLevel: String, Codable {
    case info = "info"
    case warn = "warn"
    case error = "error"
    case fatal = "fatal"
}

struct LogEntryDTO: Codable, Identifiable {
    var id: String
    var title: String?
    var body: String
}

@Model
class LogEntry: Identifiable {

    @Attribute(.unique) var id: UUID = UUID()
    var title: String? = nil
    var body: String
    var level: LogLevel = LogLevel.info
    var createdAt: Date = Date.now

    init(title: String, body: String) {
        self.title = title
        self.body = body
    }
    
    init(title: String, body: String, level: LogLevel) {
        self.title = title
        self.body = body
        self.level = level
    }
    
    init(body: String) {
        self.body = body
    }
    
    init(body: String, level: LogLevel) {
        self.body = body
        self.level = level
    }

    func toDTO() -> LogEntryDTO {
        return LogEntryDTO(
            id: self.id.uuidString,
            title: self.title,
            body: self.body
        )
    }
}
