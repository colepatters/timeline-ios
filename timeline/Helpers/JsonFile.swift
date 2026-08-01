//
//  JsonFile.swift
//  timeline
//
//  Created by Cole Patterson on 10/16/25.
//

import Foundation
import UniformTypeIdentifiers
import SwiftUI

struct JsonFile: FileDocument {
    static var readableContentTypes = [UTType.json]
    
    var text = ""
    
    init(initialText: String = "") {
        text = initialText
    }
    
    init(configuration: ReadConfiguration) throws {
        if let data = configuration.file.regularFileContents {
            text = String(decoding: data, as: UTF8.self)
        }
    }
    
    func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper {
        let data = Data(text.utf8)
        return FileWrapper(regularFileWithContents: data)
    }
}
