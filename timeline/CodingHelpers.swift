//
//  codingHelpers.swift
//  timeline
//
//  Created by Cole Patterson on 11/18/25.
//

import Foundation

func getJSONEncoder() -> JSONEncoder {
    let encoder = JSONEncoder()
    encoder.dateEncodingStrategy = .iso8601
    return encoder
}

func getJSONDecoder() -> JSONDecoder {
    let decoder = JSONDecoder()
    decoder.dateDecodingStrategy = .iso8601
    return decoder
}

