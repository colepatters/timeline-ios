//
//  ErrorAlertQueue.swift
//  timeline
//
//  Created by Cole Patterson on 11/27/25.
//

import Foundation
 
@Observable class ErrorAlert {
    var title: String
    var message: String
    var callback: (() -> Void)? = {}
    
    init(title: String, message: String, callback: (() -> Void)? = nil) {
        self.title = title
        self.message = message
        self.callback = callback
    }
}

@Observable class ErrorAlertQueue {
    private var queue: [ ErrorAlert ] = [ ErrorAlert(title: "Title", message: "Message") ]
    var length = 1
    var isEmpty: Bool = false
    
    func append(_ errorAlert: ErrorAlert) {
        queue.append(errorAlert)
        length += 1
        isEmpty = false
    }
    
    func dismissFirst() -> Void {
        queue.removeFirst()
        length -= 1
        isEmpty = queue.isEmpty
    }
}
