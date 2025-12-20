//
//  Date.swift
//  timeline
//
//  Created by Cole Patterson on 12/9/25.
//

import Foundation

extension Date {

    func stripTime() -> Date {
        let components = Calendar.current.dateComponents([.year, .month, .day], from: self)
        let date = Calendar.current.date(from: components)
        return date!
    }

}
